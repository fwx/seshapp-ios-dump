//
//  RadioHistoryViewController.swift
//  SeshRadio
//
//  Created by spooky on 8/18/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit
import RxSwift

class RadioHistoryViewController: ASViewController<ASTableNode> {
    var station: Station!
    
    private let disposeBag = DisposeBag()
    private var loadingState: LoadingState = .loading

    let tableNode = ASTableNode()
    
    private var entities: [HistoryEntity] = []
    private var mappedEntities: [Track] = []
    
    var shouldHideStuff = true
    
    init(station: Station) {
        self.station = station
        super.init(node: self.tableNode)
        
        self.tableNode.view.separatorStyle = .none
        self.tableNode.view.keyboardDismissMode = .onDrag
        
        
        self.tableNode.dataSource = self
        self.tableNode.delegate = self
        self.tableNode.backgroundColor = .navBar
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
         self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.hidesBottomBarWhenPushed = true
 
        self.navigationItem.title = self.station.title.uppercased()
        
        self.fetchTracks()
    }
    
    func fetchTracks() {
        self.loadingState = .loading
        
        RadioService
            .fetchTracks(for: self.station.object_id,
                         limit: 20,
                         offset: 0)
            .observeOn(ConcurrentDispatchQueueScheduler(queue: .global()))
            .do(onSuccess: { (response) in
                self.mappedEntities = response.results.map({ $0.song })
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] (result) in
                guard let self = self else { return }
                print(result)
                self.loadingState = .loaded
                self.entities = result.results
                self.tableNode.reloadData()
                
                
            }) { (error) in
                print(error)
        }.disposed(by: self.disposeBag)
    }
}

extension RadioHistoryViewController: ASTableDataSource, ASTableDelegate {
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.entities.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        guard self.entities.count > indexPath.row else { return { ASCellNode() } }
        
        let historyEntity = self.entities[indexPath.row]
        let entityBlock = { () -> ASCellNode in
            let node = HistoryEntityViewNode(data: historyEntity)
            node.delegate = self
            return node
        }
        
        return entityBlock
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
         guard self.entities.count > indexPath.row else { return }
        
        Utils.updatePlayer(allTracks: self.mappedEntities,
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

extension RadioHistoryViewController: PrimitiveSelection {
    func onSelected(object: Any?) {
        if object is Track {
            Utils.displayOptions(for: object as! Track,
                                 controller: self,
                                 delegate: self)
        }
    }
    
    private func pushFromOptions(root: UIViewController, dest: UIViewController) {
        root.tabBarController?.selectedIndex = 1
        

        
        guard let selectedContr = root.tabBarController?.selectedViewController as? UINavigationController else {
            return
        }
        
        DispatchQueue.main.async {
            selectedContr
                .pushViewController(dest, animated: true)
        }
    }
}

extension RadioHistoryViewController: TrackOptionsProtocol {
    func onViewAlbum(album: Album) {
        
        let block = { (controller: UIViewController) in
            let albumsController = MLTracksViewerController()
            albumsController.setDataType(.albums)
            albumsController.setAlbum(album)
            
            self.pushFromOptions(root: controller, dest: albumsController)
        }
        
        (self.navigationController as? SPKNavigationController)?.popViewController(animated: true
            , completion: { (controller) in
                block(controller)
        })
    }
    
    func onViewArtist(artist: Artist) {
        
        let block = { (controller: UIViewController) in
            let artistController = MLArtistViewController()
            artistController.artist = artist
            
            self.pushFromOptions(root: controller, dest: artistController)
        }
        
        (self.navigationController as? SPKNavigationController)?.popViewController(animated: true
            , completion: { (controller) in
                block(controller)
        })
            
        

    }
}
