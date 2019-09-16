//
//  CommonNavigationViewController.swift
//  SeshRadio
//
//  Created by spooky on 1/15/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import UIKit
import LNPopupController
import RxSwift

fileprivate let playerIdentifier = "PlayerViewController"
class CommonNavigationViewController: UITabBarController {
    
    fileprivate var miniPlayerInitialized = false
    fileprivate let disposeBag = DisposeBag()
    fileprivate var latestPlayerStatus: PlayerStatus = .paused
    // some player's controls
    
    var currentController: UIViewController?
    
    lazy var playerController: MusicLibraryPlayerViewController = {
        return UIStoryboard(name: "MusicLibrary", bundle: nil)
            .instantiateViewController(withIdentifier: playerIdentifier)
        }() as! MusicLibraryPlayerViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        self.initControllers()
        self.subscribeToPush()
    }
    
    private func subscribeToPush() {
        PushHelper
            .instance
            .tappedPush
            .filter({ $0 != .nullable })
            .subscribe(onNext: { [weak self] (type) in
                guard let self = self else { return }
                self.selectedIndex = 0
                
                guard let controller = self.viewControllers?.first as? UINavigationController else {
                    return
                }
                guard let str = PushHelper.instance.latestData as? String else {
                    return
                }
                guard let url = URL(string: str) else { return }

                Utils.openInternal(url, controller: controller)
                
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: self.disposeBag)
    }
    
    // AsyncDisplayKit workaround
    private func initControllers() {
        var controllers = self.viewControllers ?? []
        
        let searchRoot = SearchViewController()
        let searchController = UINavigationController(rootViewController: searchRoot)
        searchController.tabBarItem = UITabBarItem(title: "Search", image: nil, selectedImage: nil)
        searchRoot.title = "Search"
        
      
        
//        if #available(iOS 11.0, *) {
//            searchController.navigationBar.prefersLargeTitles = true
//            searchRoot.navigationItem.largeTitleDisplayMode = .always
//        }
        
        controllers.append(searchController)
        
        self.viewControllers = controllers
    }
    
    
    func triggerMiniPlayer() {
        // Initialize player
        self.initMiniPlayerIfNeeded()
    }
    
    
    
    
}

extension CommonNavigationViewController {
    private func initMiniPlayerIfNeeded() {
        if self.miniPlayerInitialized { return }
        
        self.playerController.tabBarRef = self
        
        // Present (allocate)
        self.presentPopupBar(withContentViewController: self.playerController,
                             animated: true,
                             completion: nil)
        
        //self.popupContentView.popupInteractionGestureRecognizer.delegate = self.playerController
        self.setMiniPlayerUI()
        
        // Progress updating
        PlayerHelper.shared.progress
            .subscribe(onNext: { [weak self] (time, progress) in
                guard let self = self else { return }
                // Update progress
                self.playerController.popupItem.progress = progress
            }, onError: nil,
               onCompleted: nil,
               onDisposed: nil).disposed(by: self.disposeBag)
        
        // Player's status
        PlayerHelper.shared.playerStatus
            .delay(RxTimeInterval.milliseconds(100), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (status) in
                guard let self = self else { return }
                if self.latestPlayerStatus == status { return }
                
                self.updateButtons(for: status)
                
                self.latestPlayerStatus = status
            }, onError: nil,
               onCompleted: nil,
               onDisposed: nil).disposed(by: self.disposeBag)
        
        
        PlayerHelper.shared.getCurrentTrack()
            .subscribe(onNext: { [weak self] (track) in
                guard let self = self else { return }
                self.playerController.popupItem.title = track.title
                self.playerController.popupItem.subtitle = track.artistsConcacted
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
        
        self.miniPlayerInitialized = true
    }
    
    private func setMiniPlayerUI () {
        self.popupBar.backgroundStyle = .dark
        self.popupBar.backgroundColor = .miniPlayerColorBg
        self.popupBar.tintColor = .miniPlayerColorTint
        self.popupBar.progressViewStyle = .bottom
        self.popupInteractionStyle = .drag
        self.popupContentView.popupCloseButtonStyle = .none
        self.popupBar.progressViewStyle = .none
        
        
    }
    
    func updateButtons(for playerStatus: PlayerStatus) {
        var buttons: [UIBarButtonItem] = []
        
        if playerStatus == .playing {
            buttons
                .append(UIBarButtonItem(barButtonSystemItem: .pause,
                                        target: self,
                                        action: #selector(CommonNavigationViewController.onPause)))
        } else {
            buttons
                .append(UIBarButtonItem(barButtonSystemItem: .play,
                                        target: self,
                                        action: #selector(CommonNavigationViewController.onPlay)))
        }
        
        buttons.append(UIBarButtonItem(barButtonSystemItem: .fastForward,
                                       target: self,
                                       action: #selector(CommonNavigationViewController.onNext)))
        
        // Update buttons
        UIView.performWithoutAnimation {
            self.playerController.popupItem.rightBarButtonItems = buttons
        }
        
    }
    
    @objc private func onPlay() {
        PlayerHelper.shared.play()
    }
    
    @objc private func onPause() {
        PlayerHelper.shared.pause()
    }
    
    @objc private func onNext() {
        PlayerHelper.shared.next(userCmd: true)
    }
}

extension CommonNavigationViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("[TabBar] controller: \(viewController)")
        
        //self.currentController = viewController
        self.playerController
            .navControllerRef = viewController as? UINavigationController
        
        if !(viewController is RadioViewController) {
            print("open popup")
        }
    }
}
