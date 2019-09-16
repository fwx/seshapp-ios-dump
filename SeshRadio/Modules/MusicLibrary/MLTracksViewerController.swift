//
//  MusicLibraryTracksViewerController.swift
//  SeshRadio
//
//  Created by spooky on 2/23/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import RxSwift

class MLTracksViewerController: MLBaseTracksViewController {
    
    private var dataType: Globals.MLSearchType = .tracks
    func setDataType(_ type: Globals.MLSearchType) { self.dataType = type }
    
    private var album: Album! {
        didSet {
            self.tracks = []
            self.fetchTracks()
        }
    }
    
    private var artist: Artist! {
        didSet {
            self.tracks = []
            self.fetchTracks()
        }
    }
    
    func setAlbum(_ album: Album) { self.album = album }
    func setArtist(_ artist: Artist) { self.artist = artist }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func fetchTracks() {
        super.fetchTracks()
        
        self.tableNode.reloadData()
        
        self.title = self.dataType == .artists ? self.artist.name : self.album.title
        
        if self.dataType == .artists {
            MusicService
                .fetchTracks(search: self.artist.name,
                             limit: 50,
                             offset: 0)
                .subscribe(onSuccess: { [weak self] (response) in
                    guard let self = self else { return }
                    
                    self.tracks = response.results
                    self.tableNode.reloadData()
                    
                }) { (error) in
                    print(error)
            }.disposed(by: self.disposeBag)
        } else if self.dataType == .albums {
            AlbumsService
                .fetchTracks(for: self.album.object_id)
                .map({ $0.songs ?? [] })
                .subscribe(onSuccess: { [weak self] (tracks) in
                    guard let self = self else { return }
                    
                    self.tracks = tracks
                    self.tableNode.reloadData()
                }) { (error) in
                    print(error)
            }.disposed(by: self.disposeBag)
        }
    }
    
}
