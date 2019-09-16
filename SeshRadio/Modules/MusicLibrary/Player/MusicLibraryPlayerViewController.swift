//
//  MusicLibraryPlayerViewController.swift
//  SeshRadio
//
//  Created by spooky on 1/20/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import UIKit
import FSPagerView
import RxSwift
import CoreMedia

fileprivate let cellIdentifier = ""

class MusicLibraryPlayerViewController: UIViewController {
    
    @IBOutlet var trackImage: UIImageView!
    @IBOutlet var trackTitle: UILabel!
    @IBOutlet var trackImageHolder: UIView!
    @IBOutlet var trackArtist: UILabel!
    
    @IBOutlet var trackCurrTime: UILabel!
    @IBOutlet var trackLeftTime: UILabel!
    @IBOutlet var trackProgress: UISlider!
    
    @IBOutlet var downloadBtn: UIButton!
    @IBOutlet var shufflerBtn: UIButton!
    @IBOutlet var repeatBtn: UIButton!
    @IBOutlet var optionsBtn: UIButton!
    
    @IBOutlet var playBtn: UIButton!
    @IBOutlet var navBarHolder: UIView!
    
    @IBOutlet var volumeControl: UIView!
    @IBOutlet var nowPlayingInfo: UILabel!
    
    // Constraints
    @IBOutlet var playBtnTopConstraint: NSLayoutConstraint!
    
    private let disposeBag = DisposeBag()
    
    //private var present: PlayerPresenter!
    var presenter: PlayerPresentProtocol!
    let configurator: PlayerConfigurationProtocol = PlayerConfigurator()
    
    var tabBarRef: UITabBarController?
    var navControllerRef: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
        self.configurator.configure(with: self)
        
        self.trackProgress.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
  
    private let seekTo = { (progress: Float) in
        let trackProgress = PlayerHelper.shared.getCurrentTrack().value.duration
        let x = progress * Float(trackProgress)
        let time = CMTimeMakeWithSeconds(Float64(x), preferredTimescale: 1)
        
        PlayerHelper.shared.seek(to: time)
    }
    
    private var latestPlayerState: PlayerStatus = .paused
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                self.latestPlayerState = PlayerHelper.shared.playerStatus.value
                PlayerHelper.shared.pause()
            case .moved:
                seekTo(slider.value)
            case .ended:
                if self.latestPlayerState == .playing {
                    PlayerHelper.shared.play()
                }
            default:
                break
            }
        }
    }
    
    
}

/* Controls */
extension MusicLibraryPlayerViewController {

    @IBAction func onDismiss(_ sender: Any) {
        
    }
    
    
    @IBAction func onPlayPause(_ sender: Any) {
        self.presenter.playPause()
    }
    
    @IBAction func onPrev(_ sender: Any) {
        self.presenter.prevTrack()
    }
    
    @IBAction func onNext(_ sender: Any) {
        self.presenter.nextTrack()
    }
    
    @IBAction func onQueueBtn(_ sender: Any) {
        self.presenter.presentQueue()
    }
    
    @IBAction func onOptions(_ sender: Any) {
        self.presenter.openOptions()
    }
    
    @IBAction func onRepeat(_ sender: Any) {
        FeedBackGenerator
            .shared
            .impact(style: .light)
        let value = PlayerHelper.shared.repeatState.value
        var newRepeat: RepeatState = .noRepeat
        
        if value == .noRepeat {
            newRepeat = .repeatPlaylist
        } else if value == .repeatPlaylist {
            newRepeat = .repeatSong
        } else if newRepeat == .repeatSong {
            newRepeat = .noRepeat
        }
        
        PlayerHelper.shared.repeatState.accept(newRepeat)
    }
    
    @IBAction func onShuffle(_ sender: Any) {
        FeedBackGenerator
            .shared
            .impact(style: .light)
        
        PlayerHelper
            .shared
            .shuffleState
            .accept(PlayerHelper.shared.lastShufflerState == .noShuffle ? .shuffle : .noShuffle)
    }
    
    @IBAction func onDownload(_ sender: Any) {
    }
}

extension MusicLibraryPlayerViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
