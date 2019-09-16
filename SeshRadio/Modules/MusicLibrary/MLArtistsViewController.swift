//
//  MusicLibraryArtistsViewController.swift
//  SeshRadio
//
//  Created by spooky on 1/10/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import DifferenceKit
import RxSwift

class MLArtistsViewController:  ASViewController<ASTableNode> {
    
    let tableNode = ASTableNode()
    
    private var artists: [Artist] = []
    private let disposeBag = DisposeBag()
    private var loadingState: LoadingState = .loading

    
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

        self.navigationItem.title = "Artists"
        self.fetchArtists()
    }
    
    
    func fetchArtists() {
        MusicService.fetchArtists(limit: 100, offset: self.artists.count)
            .subscribe(onSuccess: { (artists) in
                let artists = artists.results
                
                if artists.count == 0 {
                    self.loadingState = .loaded
                    return
                }
                
                // Artists fetching && updates
                let newArray = self.artists + artists
                
                let changeset = StagedChangeset(source: self.artists, target: newArray)
                
                self.loadingState = .loaded
                self.artists = newArray
                
                self.tableNode.performBatchUpdates({ [weak self] in
                    guard let self = self else { return }
                    let tn = self.tableNode
                    
                    changeset.forEach({ (changeSetEntity) in
                        let updateIndexes = changeSetEntity
                            .elementUpdated
                            .map({ IndexPath(row: $0.element, section: $0.section) })
                        
                        let deleteIndexes = changeSetEntity
                            .elementDeleted
                            .map({ IndexPath(row: $0.element, section: $0.section) })
                        
                        let insertIndexes = changeSetEntity
                            .elementInserted
                            .map({ IndexPath(row: $0.element, section: $0.section) })
                        
                        tn.reloadRows(at: updateIndexes,with: .automatic)
                        tn.deleteRows(at: deleteIndexes, with: .automatic)
                        tn.insertRows(at: insertIndexes, with: .automatic)
                        
                        changeSetEntity.elementMoved.forEach({ (source, target) in
                            let sourceIndex = IndexPath(row: source.element,
                                                          section: source.section)
                            let targetIndex = IndexPath(row: target.element,
                                                        section: target.section)
                            
                            tn.moveRow(at: sourceIndex, to: targetIndex)
                        })
                        
                    })
                }, completion: { (resutl) in
                    print(resutl)
                })
            }) { (error) in
                print(error)
        }.disposed(by: self.disposeBag)
    }

}

extension MLArtistsViewController: ASTableDataSource, ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.artists.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        guard self.artists.count > indexPath.row else { return { ASCellNode() } }
        
        let artist = self.artists[indexPath.row]
        let artistBlock = { () -> ASCellNode in
            let node = MLArtistViewNode(artist: artist)
            return node
        }
        
        return artistBlock
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let artist = self.artists[indexPath.row]
        let controller = MLArtistViewController()
        controller.artist = artist
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
        
        if self.loadingState != .loading && distance < 200 {
            print("P A G I N A T I O N")
            self.fetchArtists()
        }
    }
}
