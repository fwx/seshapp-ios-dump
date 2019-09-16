//
//  PlayerProtocols.swift
//  SeshRadio
//
//  Created by spooky on 1/20/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation

protocol PlayerViewProtocol {
    func setTrack()
}

protocol PlayerPresentProtocol: class {
    func configureView(track: Track)
    
    func pagerNextTrack(_ track: Track)
    func pagerPrevTrack(_ track: Track)
    
    func playPause()
    func nextTrack()
    func prevTrack()
    
    func presentQueue()
    
    func updateInfo(time: Float, progress: Float)
    func updateStatus(status: PlayerStatus)
    
    func openOptions()
    
    func updateShuffle(state: ShufflerState)
    func updateRepeat(state: RepeatState)
}

protocol PlayerInteractorProtocol {
    func createSubscribers()
    func onPagerNextTrack()
    func onPagerPrevTrack()
    
    func playPause()
    func nextTrack()
    func prevTrack()
}

protocol PlayerConfigurationProtocol {
    func configure(with viewController: MusicLibraryPlayerViewController)
}
