//
//  MusicLibraryTracksViewController.swift
//  SeshRadio
//
//  Created by spooky on 1/10/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import UIKit
import RxSwift
import AsyncDisplayKit
import IGListKit

class MLTracksViewController: MLBaseTracksViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchTracks()
    }
    
    override func fetchTracks() {
        super.fetchTracks()
        
        MusicService.fetchTracks(limit: 20, offset: self.tracks.count)
            .subscribe(onSuccess: { (tracks) in
                let tracks = tracks.results
                
                if tracks.count == 0 {
                    self.loadingState = .loaded
                    return
                }
                
                let newArray = self.tracks + tracks
                let difference = ListDiff(oldArray: self.tracks, newArray: newArray, option: .equality).forBatchUpdates()
                self.loadingState = .loaded
                self.tracks = newArray
                
                
                self.tableNode.performBatchUpdates({
                    self.tableNode.reloadRows(at: difference.updates.map({ IndexPath(row: $0, section: 0) }), with: .none)
                    self.tableNode.deleteRows(at: difference.deletes.map({ IndexPath(row: $0, section: 0) }), with: .none)
                    self.tableNode.insertRows(at: difference.inserts.map({ IndexPath(row: $0, section: 0) }), with: .none)
                    
                    difference.moves.forEach({ (move) in
                        self.tableNode.moveRow(at: IndexPath(row: move.from, section: 0), to: IndexPath(row: move.to, section: 0))
                    })
                }, completion: { (result) in
                    print(result)
                })
            }) { (error) in
                print(error)
            }.disposed(by: self.disposeBag)
    }
}


