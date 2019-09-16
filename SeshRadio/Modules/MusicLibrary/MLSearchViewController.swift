//
//  MusicLibrarySearchViewController.swift
//  SeshRadio
//
//  Created by spooky on 1/9/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import UIKit
import RxSwift
import IGListKit
import AsyncDisplayKit
import FPSCounter

fileprivate let albumIdentifier = "SearchAlbumCell"
fileprivate let artistIdentifier = "SearchArtistCell"
fileprivate let trackIdentifier = "SearchTrackCell"

class MLSearchViewController: ASViewController<ASTableNode> {
    let tableNode = ASTableNode()
    
   
    
    fileprivate var searchType: Globals.MLSearchType = .tracks
    func setSearchType(_ type: Globals.MLSearchType) { self.searchType = type }
    
    fileprivate var tracks: [Track] = []
    fileprivate var albums: [Album] = []
    fileprivate var artists: [Artist] = []
    
    fileprivate var searchText = PublishSubject<String>()
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate var parentController: UIViewController?
    func setParent(_ parentController: UIViewController) { self.parentController = parentController }
    
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
        
      
        //self.createBackground()
        self.createRx()
        
        
    }
    
    func createRx() {
        self.searchText
            .debounce(DispatchTimeInterval.milliseconds(400), scheduler: MainScheduler.instance)
            .map({ $0.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed) })
            .map({ $0 ?? "" })
            .subscribe(onNext: { (input) in
                // See what type we have and search for what user needs
                switch self.searchType {
                case .albums:
                    print("not implemented")
                case .artists:
                    print("not implemented")
                case .tracks:
                    self.searchTracks(by: input)
                }
                
            }, onError: nil, onCompleted: {
                
            }).disposed(by: self.disposeBag)
    }
    
    fileprivate var latestRequest: Disposable!
    private func searchTracks(by input: String) {
        self.latestRequest?.dispose()
        
        self.latestRequest = MusicService.searchTracks(query: input)
            .subscribe(onSuccess: { (searchResults) in
                let searchResults = searchResults.results
                
                if searchResults.count == 0 {
                    return
                }
                
                let difference = ListDiff(oldArray: self.tracks, newArray: searchResults, option: .equality).forBatchUpdates()
                self.tracks = searchResults
                
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
                
                
                //self.tableView.reloadData()
            }) { (error) in
                print(error)
        }
    }
    
    
}



extension MLSearchViewController: ASTableDataSource, ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        switch self.searchType {
        case .albums:
            return albums.count
        case .artists:
            return self.artists.count
        case .tracks:
            return self.tracks.count
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        switch self.searchType {
        case .albums:
            guard self.albums.count > indexPath.row else { return { ASCellNode() } }
        case .artists:
            guard self.artists.count > indexPath.row else { return { ASCellNode() } }
        case .tracks:
            guard self.tracks.count > indexPath.row else { return { ASCellNode() } }
        }
        
        var block: ASCellNodeBlock!
        
        switch self.searchType {
        case .tracks:
            let track = self.tracks[indexPath.row]
            block = { () -> ASCellNode in
//                let cellNode = SearchTrackNode(type: self.searchType, data: track)
//
                return ASCellNode()
            }
           
        default:
            fatalError()
        }
        
        return block
        
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        if self.searchType != .tracks { return }
        Utils.updatePlayer(allTracks: self.tracks,
                           index: indexPath.row,
                           commonNavigation: self.parentController?.commonNavigation)
    }
}

extension MLSearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        self.searchText.onNext(searchController.searchBar.text ?? "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        self.tracks = []
//        self.albums = []
//        self.artists = []
//        
//        self.tableNode.reloadData()
    }
    
}

