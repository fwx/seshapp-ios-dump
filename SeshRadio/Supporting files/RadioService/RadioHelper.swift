//
//  RadioHelper.swift
//  SeshRadio
//
//  Created by spooky on 7/15/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import MediaPlayer
import RxSwift
import RxAVFoundation

class RadioHelper: NSObject {
    static let instance = RadioHelper()
    
    private let mpic = MPNowPlayingInfoCenter.default()
    private var musicPlayer: AVPlayer! = AVPlayer(playerItem: nil) // main player
    private var playerItem: AVPlayerItem!
    
    var playerStatus = BehaviorSubject<PlayerStatus>(value: .paused)
    
    private let disposeBag = DisposeBag()
    
    private var currentStation: Station!
    
    var currentTrack = BehaviorSubject<Track>(value: Globals.kFakeTrack)
    var loadingState = BehaviorSubject<LoadingState>(value: .none)
    
    private var trackFetcher = PublishSubject<Int>()
    
    override init() {
        super.init()
        
        self
            .musicPlayer
            .rx
            .status
            .subscribe(onNext: { [weak self] (status) in
                guard let self = self else { return }
                if status == .failed {
                    self.playerStatus.onNext(.error)
                }
                
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: self.disposeBag)
        
        self
            .trackFetcher
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .do(onNext: { (_) in
                print("change observer")
            })
            .filter({ _ in self.currentStation != nil })
            .do(onNext: { (_) in
                self.loadingState.onNext(.loading)
            })
            .flatMap { (_) -> Single<Station> in
                return RadioService
                    .fetchStations()
                    .map({ (response) -> Station in
                        let station = response
                            .results
                            .first(where: { $0.object_id == self.currentStation.object_id })
                        
                        if let station = station {
                            return station
                        }
                        
                        throw API.kParseError
                    })
            }
            .catchError { (error) -> Observable<Station> in
                return Observable.just(self.currentStation)
            }
            .do(onNext: { (station) in
                self.loadingState.onNext(.loaded)
                self.updateMediaCenter(with: station.currentSong)
            })
            .subscribe(onNext: { (station) in
                self.currentTrack.onNext(station.currentSong)
                self.loadingState.dispose()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: self.disposeBag)
    }
    
    @discardableResult
    func setStation(_ station: Station) -> RadioHelper {
        self.currentStation = station
        return self
    }
    
    @discardableResult
    func initStation() -> RadioHelper {
        guard self.currentStation != nil else {
            LogBuilder()
                .setMessage("RadioHelper/Station")
                .appendParams(key: "error", value: "current station is nil")
                .send(with: .error)
            
            return self
        }
        
        guard let url = self.currentStation.streamUrl /*self.currentStation.streamUrl*/ else {
            LogBuilder()
                .setMessage("RadioHelper/URL")
                .appendParams(key: "error", value: "current url is nil")
                .send(with: .error)
            
            return self
        }
        
        // self.addObservers()
        self.playerItem = AVPlayerItem(url: url)
        
        
        return self
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard keyPath == Globals.META_DATA else {
            return
        }
        
        let playerItem = object as! AVPlayerItem
        
        if let meta = playerItem.timedMetadata, let data = meta.first, let _ = data.stringValue {
          
            
            // Post notification to all the listenrs
//            NotificationCenter.default.post(name: Constants.Notifications.ON_SONG_CHANGE, object: ["name" : title])
//
            // Proccess other stuff
           // self.onStreamChange()
            
            self.trackFetcher.onNext(1)
            
//            self.musicPlayer.pause()
//            self.musicPlayer.play()
        }
    }
    
    
    private func updateMediaCenter(with track: Track) {
        guard !track.artistsConcacted.isEmpty && !track.title.isEmpty else {
            return
        }
        
        MediaInfoHelper.shared.isRadio = true
        MediaInfoHelper.shared.track = track
        MediaInfoHelper.shared.currentTime = 0
      
//
//         var params: [String: Any] = [
//            MPMediaItemPropertyArtist : track.artistsConcacted,
//            MPMediaItemPropertyTitle : track.title!
//        ]
//
//        if !track.albumTitle.isEmpty {
//            params[MPMediaItemPropertyAlbumTitle] = track.albumTitle
//        }
//
//        let updateBlock = {
//            DispatchQueue.main.async {
//                self.mpic.nowPlayingInfo = params
//            }
//        }
//
//
//
//        DispatchQueue.global().async {
//            if let smallTrackCover = track.smallTrackCover {
//                params[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: CGSize(width: 256, height: 256)) { (size) -> UIImage in
//                    guard let data = try? Data(contentsOf: smallTrackCover) else {
//                        return UIImage()
//                    }
//
//                    if let image = UIImage(data: data) {
//                        return image
//                    }
//
//                    return UIImage()
//                }
//
//                updateBlock()
//            } else {
//                params[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: CGSize(width: 256, height: 256)) { (size) -> UIImage in
//                    return UIImage(named: "512x512") ?? UIImage()
//                }
//
//                updateBlock()
//            }
//        }
//
//
        
        
    }
    
    @discardableResult
    func prepareToPlay() -> RadioHelper {
        do  {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            //self.initInterupts()
        } catch {
            LogBuilder()
                .setMessage("RadioHelper/Session")
                .appendParams(key: "error", value: error.localizedDescription)
                .send(with: .error)
            //TODO
        }
        
        self.playerStatus.onNext(.paused)
        
        self.musicPlayer.replaceCurrentItem(with: self.playerItem)
        
        self.addObservers()
        
        return self
    }
    
    @discardableResult
    func play() -> RadioHelper {
        guard self.currentStation != nil
            && self.playerItem != nil else {
                return self
        }
        
        self.loadingState.onNext(.loading)
        self.musicPlayer.play()
        
        self.playerStatus.onNext(.playing)
        
        return self
    }
    
    @discardableResult
    func pause() -> RadioHelper {
        self.musicPlayer.pause()
        
        self.playerStatus.onNext(.paused)
        
        return self
    }
}


extension RadioHelper {
    func addObservers() {
        //self.playerItem.removeObserver(self, forKeyPath: Globals.META_DATA)
        
        // remove
        
        self.playerItem.addObserver(self, forKeyPath: Globals.META_DATA, options: .new, context: nil)
        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.playerItemDidReachEnd(_:)),
//                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
//                                               object: playerItem)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.playerItemNewErrorLogEntryNotification(_:)),
//                                               name: NSNotification.Name.AVPlayerItemNewErrorLogEntry,
//                                               object: playerItem)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.playerItemFailedtoPlayToEnd(_:)),
//                                               name: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime,
//                                               object: playerItem)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.playerItemPlaybackStalledNotification(_:)),
//                                               name: NSNotification.Name.AVPlayerItemPlaybackStalled,
//                                               object: playerItem)
    }
}
