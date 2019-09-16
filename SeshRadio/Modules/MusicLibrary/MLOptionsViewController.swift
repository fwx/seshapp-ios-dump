//
//  MLOptionsViewController.swift
//  SeshRadio
//
//  Created by spooky on 3/29/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import UIKit
import PanModal
import MBProgressHUD
import RxSwift

class MLOptionsViewController: UITableViewController {
    @IBOutlet var trackImage: UIImageView!
    @IBOutlet var trackTitle: UILabel!
    @IBOutlet var trackArtist: UILabel!
    @IBOutlet var trackDescription: UILabel!
    @IBOutlet var viewArtistBtn: UIButton!
    @IBOutlet var viewAlbumBtn: UIButton!
    
    var track: Track!
    
    weak var delegate: TrackOptionsProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.track.album == nil {
            self.viewAlbumBtn.isEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard self.track != nil else { return }
        self.trackImage.sd_setImage(with: track.trackCover, completed: nil)
        self.trackTitle.text = self.track.title
        self.trackArtist.text = self.track.artistsConcacted
    }
    

    @IBAction func onPlayNext(_ sender: Any) {
    }
    
    @IBAction func onShare(_ sender: Any) {
        let format = String(format: Globals.Strings.SHARE_FORMAT,
                            String(format: "%@ by %@", self.track.title,
                                   self.track.artistsConcacted))
        
        Utils.shareData([format], controller: self)
    }
    
    @IBAction func saveToCache(_ sender: Any) {
        var trackData = Data()
        
        _ = try? API
            .shared
            .download(self.track.trackPath.absoluteString)
            .observeOn(MainScheduler.instance)
            .do(onNext: { (input, progress) in
                print(progress)
                if let input = input {
                    trackData.append(input)
                }
            })
            .subscribe(onNext: nil, onError: { (error) in
                print(error)
            }, onCompleted: { [weak self] in
                guard let self = self else { return }
                guard trackData.count == self.track.size else {
                    fatalError("wrong track data")
                }
                
                CacheService
                    .instance
                    .saveToCache(track: self.track, data: trackData)
                print("saving to cache")
            }, onDisposed: nil)
        
        
    }
    
    @IBAction func onViewAlbum(_ sender: Any) {
        guard let albumobject_id = self.track.album else {
            return
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        _ = AlbumsService
            .fetchAlbum(albumobject_id)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] (album) in
                guard let self = self else { return }
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                FeedBackGenerator.shared.impact(style: .light)
                self.dismiss(animated: true, completion: {
                     self.delegate?.onViewAlbum(album: album)
                })
                
               
                
            }) { [weak self] (error) in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                print(error)
        }
        
    }
    
    @IBAction func onViewArtist(_ sender: Any) {
        guard let artist = self.track.artists.first else {
            return
        }
        
         MBProgressHUD.showAdded(to: self.view, animated: true)
        
        _ = TeamService
            .fetchMember(artist)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] (artist) in
                guard let self = self else { return }
                
                MBProgressHUD.hide(for: self.view, animated: true)
                FeedBackGenerator.shared.impact(style: .light)
                
                
                self.dismiss(animated: true, completion: {
                    self.delegate?.onViewArtist(artist: artist)
                })
                
            }) { [weak self] (error) in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                print(error)
        }
    }
}

extension MLOptionsViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return self.tableView
    }
    
    var shortFormHeight: PanModalHeight {
        return longFormHeight
    }
}
