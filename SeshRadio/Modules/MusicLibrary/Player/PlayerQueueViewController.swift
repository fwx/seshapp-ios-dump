//
//  PlayerQueueViewController.swift
//  SeshRadio
//
//  Created by spooky on 5/4/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import RxSwift
import DeckTransition
import PanModal


class PlayerQueueViewController: ASViewController<ASTableNode> {

    private let tableNode = ASTableNode()
    var tracks: [Track] = [] {
        didSet {
            self.tableNode.reloadData()
        }
    }
    let disposeBag = DisposeBag()
    
   
    init() {
        super.init(node: self.tableNode)
        
        self.tableNode.view.separatorStyle = .none
        self.tableNode.view.keyboardDismissMode = .onDrag
        
        self.tableNode.dataSource = self
        self.tableNode.delegate = self
        self.tableNode.backgroundColor = .navBar
        
        PlayerHelper
            .shared
            .tracks
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (tracks) in
//            var oldTracks = self.trackList
//            self.trackList = tracks
//            self.presenter.reloadMemory()
//            self.presenter.reloadMemoryTable(oldTracks: oldTracks)
//            oldTracks = []
            self.tracks = tracks
            
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension PlayerQueueViewController: ASTableDataSource, ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.tracks.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        guard self.tracks.count > indexPath.row else { return { ASCellNode() } }
        
        let track = self.tracks[indexPath.row]
        let trackBlock = { () -> ASCellNode in
            let node = MusicLibraryViewNode(type: .tracks, data: track, scaleFactor: 0.5)
            
            //node.delegate = self
            return node
        }
        
        return trackBlock
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        Utils.updatePlayer(allTracks: self.tracks,
                           index: indexPath.row,
                           commonNavigation: self.commonNavigation)
       
        (self.presentationController as? DeckSnapshotUpdater)?.requestPresentedViewSnapshotUpdate()
    }
    

}

extension PlayerQueueViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return self.tableNode.view
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(300)
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeight
    }
    
}
