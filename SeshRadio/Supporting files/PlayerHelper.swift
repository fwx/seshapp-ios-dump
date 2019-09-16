//
//  PlayerHelper.swift
//  SeshRadio
//
//  Created by spooky on 12/15/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import Foundation
import RxSwift
import RxAVFoundation
import RxCocoa
import AVFoundation
import MediaPlayer
import SDWebImage

class PlayerHelper {
    static let shared = PlayerHelper()
    fileprivate let disposeBag = DisposeBag()
    
    private var currentTrack = BehaviorRelay<Track>(value: Globals.kFakeTrack)
    func getCurrentTrack() -> BehaviorRelay<Track> { return self.currentTrack }
    
    private let mediaCenter = MPNowPlayingInfoCenter.default()
    
    // Inside the class: { get, set }
    // Outside: { get }
    let playerStatus = BehaviorRelay<PlayerStatus>(value: .paused)
    let repeatState = BehaviorRelay<RepeatState>(value: .noRepeat)
    
    let shuffleState = BehaviorRelay<ShufflerState>(value: .noShuffle)
    var lastShufflerState: ShufflerState = .noShuffle
    
    
    lazy var progress: Observable<(Float, Float)> = {
        return self.player.rx.periodicTimeObserver(interval: CMTime(seconds: 0.6, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
            .map { (time) -> (Float, Float) in
                let currentTime = time.asFloat
                let progress = currentTime / Float(self.currentTrack.value.duration)
                return (currentTime, progress)
        }
    }()
    
    fileprivate var player: AVPlayer
    var tracks = BehaviorRelay<[Track]>(value: [])
    
    init() {
        self.player = AVPlayer()
        self.player.automaticallyWaitsToMinimizeStalling = false
        
        self.createObservers()
        
        UIApplication
            .shared
            .beginReceivingRemoteControlEvents()
    }
    
    func createObservers() {
        self
            .playerStatus
            .subscribe(onNext: { (status) in
            self.updateMediaCenterData()
        }, onError: nil,
           onCompleted: nil,
           onDisposed: nil).disposed(by: self.disposeBag)
        
        self
            .shuffleState
            .observeOn(ConcurrentDispatchQueueScheduler(queue: .global()))
            .subscribe(onNext: { [weak self] (state) in
                guard let self = self else { return }
                
                guard self.lastShufflerState != state else {
                    return
                }
                
                if state == .noShuffle {
                    self.setMemory(tracks: self.originalTracks)
                } else {
                    let newTracks = self.originalTracks.shuffled()
                    self.setMemory(tracks: newTracks)
                }
                
                self.lastShufflerState = state
                
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: self.disposeBag)
        
        
    }
    
    // Before shuffle
    private var originalTracks: [Track] = []
    
    // Update in memory list
    func setMemory(tracks: [Track]) {
        self.originalTracks = tracks
        self.tracks.accept(self.originalTracks)
    }
    
    func setTrack(_ track: Track, shouldPlay: Bool = true) {
        self.pause()
        
        if CacheService.instance.isCached(trackId: track.object_id) {
            let item = AVPlayerItem(url: CacheService.instance.getPathForTrack(by: track.object_id))
            NotificationCenter
                .default
                .removeObserver(self,
                                name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                object: nil)
            
            NotificationCenter
                .default
                .addObserver(self,
                             selector: #selector(self.avPlayerItemDidReachEnd(_:)),
                             name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                             object: nil)
            
            self.player.replaceCurrentItem(with: item)
        } else {
            
            let item = CachableAVItem(track: track)
            item.delegate = self
            
            self.player.replaceCurrentItem(with: item)
        }
        
        self.currentTrack.accept(track)
        
        
        if shouldPlay {
            self.play()
        }
        
    }
    
    func seek(to: CMTime) {
         self.player.seek(to: to)
    }
    
}

extension PlayerHelper {
    
    func playPause() {
        if self.playerStatus.value == .playing {
            self.pause()
        } else {
            self.play()
        }
    }
    
    func play() {
        do {
            try AVAudioSession.sharedInstance()
                .setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("player error: \(error)")
        }
        
        self.playerStatus.accept(.playing)
        self.player.play()
        
    }
    
    func pause() {
        self.playerStatus.accept(.paused)
        self.player.pause()
    }
    
    func next(userCmd: Bool = false) {
        if self.tracks.value.count == 0 { return }
        
        guard let trackIndex = self
            .tracks.value
            .firstIndex(where: { $0.object_id == self.currentTrack.value.object_id }) else { return }
        
        var newTrackIndex = trackIndex + 1
        
        // Not user input
        if userCmd {
            if newTrackIndex > self.tracks.value.count - 1 {
                newTrackIndex = 0
            }
        } else {
            if self.repeatState.value == .repeatSong {
                newTrackIndex = trackIndex
            } else if self.repeatState.value == .repeatPlaylist {
                if newTrackIndex > self.tracks.value.count - 1 {
                    newTrackIndex = 0
                }
            }
        }
        
        let track = self.tracks.value[newTrackIndex]
        self.setTrack(track, shouldPlay: self.playerStatus.value == .playing ? true : false)
    }
    
    func prev(userCmd: Bool = false) {
        guard self.tracks.value.count != 0 else { return }
        
        
        guard let trackIndex = self
            .tracks.value
            .firstIndex(where: { $0.object_id == self.currentTrack.value.object_id }) else { return }
        
        var newTrackIndex = trackIndex - 1
        
        let time = CMTimeGetSeconds(self.player.currentTime())
        if time > 5 {
            newTrackIndex = trackIndex
        }
        
        if newTrackIndex < 0 {
            newTrackIndex = 0
        }
        
        if !userCmd {
            if self.repeatState.value == .repeatSong {
                newTrackIndex = trackIndex
            }
        }
        
        let track = self.tracks.value[newTrackIndex]
        self.setTrack(track, shouldPlay: self.playerStatus.value == .playing ? true : false)
    }
}


extension PlayerHelper: CachableAVItemDelegate {
    func playerItem(_ playerItem: CachableAVItem,
                    didFinishDownloadingData data: Data) {
        
        guard Globals.automaticallyCacheTracks == true else {
            return
        }
        
        
        CacheService
            .instance
            .saveToCache(item: playerItem,
                         track: self.currentTrack.value,
                         data: data)
    }
    
    func playerItem(_ playerItem: CachableAVItem,
                    didDownloadBytesSoFar bytesDownloaded: Int,
                    outOf bytesExpected: Int) {
        
        print("\(bytesDownloaded)/\(bytesExpected)")
        
    }
    
    func playerItemDidReachEnd(_ playerItem: CachableAVItem) {
        print("did reach end")
        
        self.next(userCmd: false)
    }
    
    @objc func avPlayerItemDidReachEnd(_ item: AVPlayerItem) {
        self.next(userCmd: false)
    }
}

// Media Center
extension PlayerHelper {
    fileprivate func updateMediaCenterData() {
        let track = self.currentTrack.value
        
        MediaInfoHelper.shared.track = track
        
//        if self.mediaCenter.nowPlayingInfo != nil && self.player.currentItem != nil {
//            // ignore
//            if let nowPlaying = self.mediaCenter.nowPlayingInfo?[MPMediaItemPropertyTitle] as? String {
//                if nowPlaying == track.getTitle() { return }
//            }
//        }
//
//        DispatchQueue.global().async {
//
//            var params: [String: Any] = [ MPMediaItemPropertyArtist : track.getArtist(), MPMediaItemPropertyTitle : track.getTitle(), MPMediaItemPropertyPlaybackDuration : track.getDuration(), MPNowPlayingInfoPropertyPlaybackRate : 1 ]
//
//
//            // URL is broken
//            guard let url = track.getTrackCover() else {
//                self.setMediaCenterData(params: params)
//                return
//            }
//
//
//            guard let imageData = try? Data(contentsOf: url) else {
//                DispatchQueue.global().async {
//                    if let cachedImage = SDImageCache.shared().imageFromCache(forKey: track.getTrackCover()?.absoluteString) {
//
//                        params[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: cachedImage.size, requestHandler: { (_) -> UIImage in
//                            return cachedImage
//                        })
//                    }
//
//                    self.setMediaCenterData(params: params)
//                }
//                return
//            }
//
//            guard let image = UIImage(data: imageData) else { return }
//
//            let mediaArtWork = MPMediaItemArtwork(boundsSize: image.size,
//                                         requestHandler: { (_size) -> UIImage in
//                return image
//            })
//            params[MPMediaItemPropertyArtwork] = mediaArtWork
//
//            self.setMediaCenterData(params: params)
//
//        }
        
    }
    
    fileprivate func setMediaCenterData(params: [String: Any]) {
        DispatchQueue.main.async {
            self.mediaCenter.nowPlayingInfo = params
        }
    }
    
}


enum PlayerStatus {
    case paused
    case playing
    case waitingForNext
    case waitingForPrev
    case error
}

enum RepeatState: Int {
    case noRepeat = 0
    case repeatSong = 1
    case repeatPlaylist = 2
}

enum ShufflerState: Int {
    case noShuffle = 0
    case shuffle = 1
}
