//
//  MusicLibraryAlbumsViewController.swift
//  SeshRadio
//
//  Created by spooky on 1/10/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import UIKit
import RxSwift
import AsyncDisplayKit
import IGListKit

class MLAlbumsViewController: ASViewController<ASTableNode> {
    let tableNode = ASTableNode()
    
    private var albums: [Album] = []
    private let disposeBag = DisposeBag()
    private var loadingState: LoadingState = .loading
    
    var artist: Artist!
    
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

        self.navigationItem.title = "Albums"
        self.fetchAlbums()
    }
    
    private func update(albums: [Album]) {
        let albums = albums
        
        if albums.count == 0 {
            self.loadingState = .loaded
            return
        }
        
        
        let newArray = self.albums + albums
        let difference = ListDiff(oldArray: self.albums, newArray: newArray, option: .equality).forBatchUpdates()
        self.loadingState = .loaded
        self.albums = newArray
        
        
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
    }
    
    func fetchAlbums() {
        self.loadingState = .loading
        
        if self.artist == nil {
            AlbumsService
                .fetchAlbums(limit: 100, offset: self.albums.count)
                .subscribe(onSuccess: { [weak self] (albums) in
                    guard let self = self else { return }
                    
                    self.update(albums: albums.results)
                }) { (error) in
                    print(error)
                }.disposed(by: self.disposeBag)
        } else {
            AlbumsService
                .fetchAlbumsFor(artistobject_id: self.artist.name,
                                limit: 100,
                                offset: self.albums.count)
                .subscribe(onSuccess: { [weak self] (albums) in
                    guard let self = self else { return }
                    
                    self.update(albums: albums.results)
                }) { (error) in
                    print(error)
                }.disposed(by: self.disposeBag)
        }
        
       
    }
}

extension MLAlbumsViewController: ASTableDataSource, ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        guard self.albums.count > indexPath.row else { return { ASCellNode() } }
        
        let album = self.albums[indexPath.row]
        let albumBlock = { () -> ASCellNode in
            let node = MusicLibraryViewNode(type: .albums, data: album)
            return node
        }
        
        return albumBlock
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let album = self.albums[indexPath.row]
        print("album: \(album)")
        
        let controller = MLTracksViewerController()
        controller.setDataType(.albums)
        controller.setAlbum(album)
        
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
        
        if self.loadingState != .loading && distance < 200 {
            print("P A G I N A T I O N")
            self.fetchAlbums()
        }
    }
}
