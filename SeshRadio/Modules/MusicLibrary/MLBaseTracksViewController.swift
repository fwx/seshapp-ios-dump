//
//  MusicLibraryBaseTracksViewController.swift
//  SeshRadio
//
//  Created by spooky on 2/23/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import RxSwift

class MLBaseTracksViewController: ASViewController<ASTableNode> {
    
    let tableNode = ASTableNode()
    
    
    var tracks: [Track] = []
    let disposeBag = DisposeBag()
    var loadingState: LoadingState = .loading
    
    init() {
        super.init(node: self.tableNode)
        
        self.tableNode.view.separatorStyle = .none
        self.tableNode.view.keyboardDismissMode = .onDrag
        
        
        self.tableNode.dataSource = self
        self.tableNode.delegate = self
        self.tableNode.backgroundColor = .navBar
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Songs"
        
       // self.fetchTracks()
    }
    
    func fetchTracks() {
        self.loadingState = .loading
    }
    
}

extension MLBaseTracksViewController: ASTableDataSource, ASTableDelegate {
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.tracks.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        guard self.tracks.count > indexPath.row else { return { ASCellNode() } }
        
        let track = self.tracks[indexPath.row]
        let trackBlock = { () -> ASCellNode in
            let node = MusicLibraryViewNode(type: .tracks, data: track)
            node.delegate = self
            return node
        }
        
        return trackBlock
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        Utils.updatePlayer(allTracks: self.tracks,
                           index: indexPath.row,
                           commonNavigation: self.commonNavigation)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
        
        if self.loadingState != .loading && distance < 200 {
            print("P A G I N A T I O N")
            self.fetchTracks()
        }
    }
}

extension MLBaseTracksViewController: PrimitiveSelection {
    func onSelected(object: Any?) {
        if object is Track {
            Utils.displayOptions(for: object as! Track, controller: self)
        }
    }
}
