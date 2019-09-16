//
//  PlayerPresenter.swift
//  SeshRadio
//
//  Created by spooky on 1/20/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import FSPagerView
import AsyncDisplayKit
import SDWebImage
import MediaPlayer
import PanModal
import DeckTransition


fileprivate let bufferedCellIdentifier = "MLPTrackCell"
fileprivate let cellIdentifier = "PlayerTrackCell"
class PlayerPresenter: NSObject, PlayerPresentProtocol {
    weak var controller: MusicLibraryPlayerViewController!
    
    var interactor: PlayerInteractor!
    private lazy var queueController: PlayerQueueViewController = {
        return PlayerQueueViewController()
    }()
    
    required init(controller: MusicLibraryPlayerViewController) {
        self.controller = controller
        
    }
    
    private func createVolumeControl() {
        guard let holder = self.controller.volumeControl else { return }
        let volumeView = MPVolumeView(frame: holder.frame)
        volumeView.showsVolumeSlider = true
        volumeView.showsRouteButton = true
        volumeView.translatesAutoresizingMaskIntoConstraints = false
        
        holder.addSubview(volumeView)
        holder.backgroundColor = .clear
        
        //volumeView.center = holder.center
        
        NSLayoutConstraint.activate([
            volumeView.topAnchor.constraint(equalTo: holder.topAnchor),
            volumeView.leftAnchor.constraint(equalTo: holder.leftAnchor),
            volumeView.rightAnchor.constraint(equalTo: holder.rightAnchor),
            volumeView.bottomAnchor.constraint(equalTo: holder.bottomAnchor)
            ])
    }
  
    
    func configureView(track: Track) {
        self.controller.trackProgress.value = 0
        self.controller.nowPlayingInfo.text = String(format: "%@ - «%@»",
                                                     track.artistsConcacted,
                                                     track.title)
        
        self.createVolumeControl()
        
        self.controller.trackTitle.text = track.title
        self.controller.trackArtist.text = track.artistsConcacted
        self.controller.trackImage.sd_setImage(with: track.trackCover, completed: nil)
    }
    
    
    func pagerNextTrack(_ track: Track) { self.interactor.onPagerNextTrack() }
    
    func pagerPrevTrack(_ track: Track) { self.interactor.onPagerPrevTrack()  }
    
    func playPause() { self.interactor.playPause() }
    
    func nextTrack() {  self.interactor.nextTrack() }
    
    func prevTrack() { self.interactor.prevTrack() }
    
    func updateInfo(time: Float, progress: Float) {
        self.controller.trackProgress.setValue(progress, animated: true)
        self.controller.trackCurrTime.text = time.asTime
    }
    
    func updateStatus(status: PlayerStatus) {
        self.controller.playBtn
            .setImage(UIImage(named: status == .playing ? "ic_pause" : "ic_play"), for: .normal)
       
        //trackImageHolder
        let transform = CGAffineTransform(scaleX: status == .playing ? 1 : 0.7, y: status == .playing ? 1 : 0.7)
        UIView.animate(withDuration: 0.5) {
            self.controller.trackImage.transform = transform
            self.controller.trackImageHolder.transform = transform
        }
       
    }

  
    
    func presentQueue() {
//        let transitionDelegate = DeckTransitioningDelegate()
//        queueController.transitioningDelegate = transitionDelegate
//        queueController.modalPresentationStyle = .custom
//        self.controller.present(queueController, animated: true, completion: nil)
        
        self.controller.presentPanModal(queueController)
        //self.controller.present(self.queueController, animated: true, completion: nil)
    }
    
    func openOptions() {
        let track = PlayerHelper.shared.getCurrentTrack().value
        
        Utils.displayOptions(for: track,
                             controller: self.controller,
                             delegate: self)
    }
    
    func updateRepeat(state: RepeatState) {
        guard let controller = self.controller else { return }
        switch state {
        case .noRepeat:
            controller.repeatBtn.setImage(UIImage(named: "ic_repeat_none"), for: .normal)
        case .repeatSong:
            controller.repeatBtn.setImage(UIImage(named: "ic_repeat_single"), for: .normal)
        case .repeatPlaylist:
            controller.repeatBtn.setImage(UIImage(named: "ic_repeat"), for: .normal)
        }
    }
    
    func updateShuffle(state: ShufflerState) {
        if state == .noShuffle {
            self.controller.shufflerBtn.setImage(UIImage(named: "ic_shuffle_none"), for: .normal)
        } else {
            self.controller.shufflerBtn.setImage(UIImage(named: "ic_shuffle"), for: .normal)
        }
    }
}

extension PlayerPresenter: FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.interactor.trackList.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        guard let cell = pagerView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                       at: index) as? PlayerTrackCell else { fatalError() }
        
        let track = self.interactor.trackList[index]
        
        cell.setImageUrl(track.trackCover)
        
        return cell
    }
}

extension PlayerPresenter: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Qeueue"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.interactor.trackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: bufferedCellIdentifier) as! MLPTrackCell
        
        cell.setTrack(self.interactor.trackList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Utils.updatePlayer(allTracks: self.interactor.trackList, index: indexPath.row)
    }
    
}


extension PlayerPresenter: TrackOptionsProtocol {
    func onViewAlbum(album: Album) {
        self.controller
            .tabBarRef?
            .closePopup(animated: true, completion: { [weak self] in
                guard let self = self else { return }
                let controller = MLTracksViewerController()
                controller.setDataType(.albums)
                controller.setAlbum(album)
                
                DispatchQueue.main.async {
                    self.controller.navControllerRef?.pushViewController(controller, animated: true)
                }
            })
    }
    
    //MLArtistViewController
    func onViewArtist(artist: Artist) {
        self.controller
            .tabBarRef?
            .closePopup(animated: true, completion: { [weak self] in
                guard let self = self else { return }
                let controller = MLArtistViewController()
                controller.artist = artist
                
                DispatchQueue.main.async {
                    self.controller.navControllerRef?.pushViewController(controller, animated: true)
                }
            })
    }
}
