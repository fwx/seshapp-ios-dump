//
//  RadioViewController.swift
//  SeshRadio
//
//  Created by spooky on 12/15/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import UIKit
import RxSwift
import FSPagerView
import SDWebImage

fileprivate let cellIdentifier = "StationViewCell"
class RadioViewController: UIViewController {
    
    @IBOutlet var stationsView: FSPagerView!
    @IBOutlet var overlayView: UIView!
    @IBOutlet var titleView: SESHTextView!
    @IBOutlet var descView: SESHTextView!
    @IBOutlet var bgView: UIImageView!
    @IBOutlet var loadingView: UILabel!
    @IBOutlet var radioState: UIImageView!
    
    private var disposeBag: DisposeBag! = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private var stations: [Station] = [] {
        didSet {
            self.stationsView.reloadData()
        }
    }
    
    deinit {
        self.disposeBag = nil
    }
    
    
    // should be the same (-.2) as
    // stationsView.height relation to superview
    private var calculatedHeight: CGFloat = 0
    
    var selectedStationIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.navBarTint
        self.overlayView.backgroundColor = UIColor.navBarTint.withAlphaComponent(0.85)
        
        self.calculatedHeight = self.view.bounds.width * 0.345

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        //self.createBackground()
        self.initPagerView()
        self.fetchStations()
        self.listenToTrack()
        
        
        self
            .radioState
            .addGestureRecognizer(UITapGestureRecognizer(target: self,action: #selector(self.onRadioBtn(_:))))
    }
    
    @objc func onRadioBtn(_ sender: Any) {
        print("on kek")
        
        guard let status = try? RadioHelper.instance.playerStatus.value() else {
            return
        }
        
        if status == .playing {
            RadioHelper.instance.pause()
        } else {
            RadioHelper.instance.play()
        }
    }
    
    private func listenToTrack() {
        RadioHelper
            .instance
            .loadingState
            .subscribe(onNext: { [weak self] (state) in
                guard let self = self else { return }
                
                switch state {
                case .none:
                    self.loadingView.text = ""
                case .loading:
                    self.loadingView.text = "loading"
                case .loaded:
                    self.loadingView.text = "loaded"
                case .error:
                    self.loadingView.text = "error"
                }
                
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: self.disposeBag)
        
        RadioHelper
            .instance
            .currentTrack
            .filter({ $0.object_id != Globals.kFakeTrack.object_id })
            .observeOn(ConcurrentDispatchQueueScheduler(queue: .global()))
            .do(onNext: { [weak self] (track) in
                guard let strongSelf = self else { return }
                SDWebImageDownloader
                    .shared
                    .downloadImage(with: track.trackCover, completed: { [weak strongSelf] (image, _, _, _) in
                        guard let strongSelf = strongSelf else { return }
                        
                        UIView.transition(with: strongSelf.bgView, duration: 1.5, options: .transitionCrossDissolve, animations: {
                            //DispatchQueue.main.async {
                                strongSelf.bgView.image = image
                            //}
                        }, completion: nil)
                    })
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (track) in
                guard let self = self else { return }
                self.titleView.text = track.artistsConcacted
                self.descView.text = track.title
                
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        RadioHelper
            .instance
            .playerStatus
            .subscribe(onNext: { [weak self] (status) in
                guard let self = self else { return }
                
                
                if status == .playing {
                    let animation = CABasicAnimation(keyPath: "transform.scale")
                    animation.fromValue = 1
                    animation.toValue = 0.8
                    animation.repeatCount = Float.infinity
                    animation.autoreverses = true
                    animation.isRemovedOnCompletion = false
                    animation.speed = 0.25
                    
                    self.radioState.layer.add(animation, forKey: "anim")
                } else {
                    self.radioState.layer.removeAllAnimations()
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    
    func fetchStations() {
        RadioService
            .fetchStations()
            .filter({ $0.results.count > 0 })
            .subscribe(onSuccess: { [weak self] (response) in
                guard let self = self else { return }
                let stations = response.results
                self.stations = stations
                
            }, onError: { (error) in
                print(error)
            }, onCompleted: nil)
            .disposed(by: self.disposeBag)
    }
    
    func initPagerView() {
        self.stationsView
            .register(UINib(nibName: cellIdentifier, bundle: nil),
                      forCellWithReuseIdentifier: cellIdentifier)
        self.stationsView.itemSize = CGSize(width: calculatedHeight, height: calculatedHeight)
        self.stationsView.dataSource = self
        self.stationsView.delegate = self
        //self.stationsView.scrollOffset = 30
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.backgroundColor = .clear
        self.tabBarController?.tabBar.barTintColor = .clear
        self.tabBarController?.tabBar.shadowImage = UIImage()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.backgroundColor = .seshTabBar
        self.tabBarController?.tabBar.barTintColor = .seshTabBar
        
    }
    
    @IBAction func onHistoryPressed(_ sender: Any) {
        guard self.selectedStationIndex != -1 else {
            print("toprofel")
            return
        }
        
        let controller = RadioHistoryViewController(station: self.stations[self.selectedStationIndex])
        controller.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension RadioViewController: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.stations.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        guard let cell = pagerView
            .dequeueReusableCell(withReuseIdentifier: cellIdentifier, at: index) as? StationViewCell else { fatalError() }
        
        let station = self.stations[index]
        cell.setTitle(station.title)
        cell.setImage(station.logoSmallUrl)
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        guard self.selectedStationIndex != index else {
            // just play || ignore
            // who knows
//            RadioHelper
//                .instance
//                .play()
            return
        }
        
        let station = self.stations[index]
        
        RadioHelper
            .instance
            .setStation(station)
            .initStation()
            .prepareToPlay()
            .play()
        
        self.selectedStationIndex = index
    }
    
    
}
