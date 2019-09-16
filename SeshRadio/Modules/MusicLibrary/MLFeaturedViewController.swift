//
//  MusicLibraryFeaturedController.swift
//  SeshRadio
//
//  Created by spooky on 2/23/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import RxSwift

class MLFeaturedViewController: ASViewController<ASTableNode> {
    let tableNode = ASTableNode(style: .grouped)
    
    private let disposeBag = DisposeBag()
    
    var featured: Featured! {
        didSet {
            self.tableNode.dataSource = self
            self.tableNode.delegate = self
            
            self.fetchTracks()
        }
    }
    
    var tracks: [Track] = [] {
        didSet {
            self.tableNode.reloadData()
        }
    }
    
    lazy var headerNode = {
       return MLFeaturedHeaderHolder(height: 125, featured: self.featured)
    }()
    
    init() {
        super.init(node: self.tableNode)
       
        self.configureAppereance()
    }
    
    func fetchTracks() {
        PlaylistsService
            .fetchTracks(for: self.featured.object_id)
            .map({ $0.songs ?? [] })
            .subscribe(onSuccess: { [weak self] (tracks) in
                guard let self = self else { return }
                self.tracks = tracks
            }) { (error) in
                print(error)
        }.disposed(by: self.disposeBag)
    }
    
    func configureAppereance() {
        self.tableNode.backgroundColor = .navBar
        self.tableNode.view.separatorStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MLFeaturedViewController: ASTableDataSource, ASTableDelegate, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tracks.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 0 else { return 0 }
        
        let size = ASSizeRangeMake(.zero, self.tableNode.bounds.size)
        return self.headerNode.calculateLayoutThatFits(size).size.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.headerNode.featuredView
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        guard self.tracks.count > indexPath.row else { return { ASCellNode() } }
        
        let track = self.tracks[indexPath.row]
        let trackBlock = { () -> ASCellNode in
            let node = MusicLibraryViewNode(type: .tracks, data: track, hideCover: true)
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
}

extension MLFeaturedViewController: PrimitiveSelection {
    func onSelected(object: Any?) {
        if object is Track {
            Utils.displayOptions(for: object as! Track, controller: self)
        }
    }
}
