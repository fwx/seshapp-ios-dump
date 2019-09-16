//
//  SearchViewController.swift
//  SeshRadio
//
//  Created by spooky on 9/3/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import RxSwift

class SearchViewController: ASViewController<ASTableNode> {
    let tableNode = ASTableNode()
    let disposeBag = DisposeBag()
    
    var objects: [SearchResult] = []
    
    init() {
        super.init(node: tableNode)
        
        self.tableNode.dataSource = self
        self.tableNode.delegate = self
        
        self.configureAppereance()
        self.initSearchBar()
        
        print("search initialized")
    }
    
    func configureAppereance() {
        self.tableNode.backgroundColor = .navBar
        self.tableNode.view.separatorStyle = .none
    }
    
    private func initSearchBar() {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = UIColor.navBarTint
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
        
        searchBar
            .rx
            .text
            .skip(1)
            .filter({ $0 != nil })
            .map({ $0! })
            .debounce(RxTimeInterval.milliseconds(700),
                      scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { (input) -> Observable<ArrayResponse<SearchResult>> in
                return SearchService
                    .search(query: input).asObservable()
                    .catchError({ (_) -> Observable<ArrayResponse<SearchResult>> in
                        return Observable.just(ArrayResponse(count: 0, next: "", previous: "", results: []))
                    })
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (response) in
                guard let self = self else { return }
                self.objects = response.results.filter({ $0.type != .notSupported })
                self.tableNode.reloadData()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

extension SearchViewController: ASTableDataSource, ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.objects.count
    }
    
    
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        guard self.objects.count > indexPath.row else { return { ASCellNode() } }
        
        let object = self.objects[indexPath.row]
        let block = { () -> ASCellNode in
            let cellNode = SearchTrackNode(type: object.type, data: object.base!)
            
            return cellNode
        }
        
        return block
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        guard self.objects.count > indexPath.row else { return  }
        
        let object = self.objects[indexPath.row]
        
        if object.type == .member {
            let artistVc = MLArtistViewController()
            artistVc.artist = object.base as? Artist
            
            self.navigationController?.pushViewController(artistVc, animated: true)
        } else if object.type == .album {
            let tracksVc = MLTracksViewerController()
            tracksVc.setDataType(.albums)
            tracksVc.setAlbum(object.base as! Album)
            
            self.navigationController?.pushViewController(tracksVc, animated: true)
        } else if object.type == .song {
            let tracks = self.objects.filter({ $0.type == .song }).map({ $0.base }) as! [Track]
            guard let index = tracks.firstIndex(where: { $0.object_id == (object.base as! Track).object_id }) else {
                return
            }
            
            Utils.updatePlayer(allTracks: tracks,
                               index: index,
                               commonNavigation: self.commonNavigation)
        }
    }
}
