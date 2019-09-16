//
//  PlayerInteractor.swift
//  SeshRadio
//
//  Created by spooky on 1/20/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import RxSwift

class PlayerInteractor: PlayerInteractorProtocol {
    weak var presenter: PlayerPresentProtocol!
    
    private let disposeBag = DisposeBag()
    
    var trackList: [Track] = []
    
    required init(presenter: PlayerPresentProtocol) {
        self.presenter = presenter
    }
    
    func createSubscribers() {
        // Subscribe to track changes
        PlayerHelper.shared.getCurrentTrack().subscribe(onNext: { (track) in
            self.presenter.configureView(track: track)
            
            guard self.trackList.count > 0 else { return }
            guard let index = self.trackList
                .firstIndex(where: { $0.object_id == PlayerHelper.shared.getCurrentTrack().value.object_id }) else { return }
            
            //self.presenter.setNewTrack(newIndex: index)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
        
        // Subscribe to player status
        PlayerHelper.shared.playerStatus.subscribe(onNext: { (status) in
            self.presenter.updateStatus(status: status)
        }).disposed(by: self.disposeBag)
        
        // Subscribe to track data
        PlayerHelper.shared.progress.subscribe(onNext: { (time, progress) in
            self.presenter.updateInfo(time: time, progress: progress)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
        
        PlayerHelper
            .shared
            .tracks
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (tracks) in
                var oldTracks = self.trackList
                self.trackList = tracks
                
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
        
        PlayerHelper
            .shared
            .shuffleState
            .subscribe(onNext: { [weak self] (state) in
                guard let self = self else { return }
                
                self.presenter.updateShuffle(state: state)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: self.disposeBag)
        
        PlayerHelper
            .shared
            .repeatState
            .subscribe(onNext: { [weak self] (state) in
                guard let self = self else { return }
                self.presenter.updateRepeat(state: state)
                
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: self.disposeBag)
    }
    
    func onPagerNextTrack() {
        PlayerHelper.shared.next(userCmd: true)
    }
    
    func onPagerPrevTrack() {
        PlayerHelper.shared.prev()
    }
    
    func playPause() {
        // play pause
        PlayerHelper.shared.playPause()
    }
    
    func nextTrack() {
        PlayerHelper.shared.next(userCmd: true)
    }
    
    func prevTrack() {
        PlayerHelper.shared.prev(userCmd: true)
    }
    
}
