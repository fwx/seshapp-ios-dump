//
//  MLOfflineViewController.swift
//  SeshRadio
//
//  Created by spooky on 7/16/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit
import RealmSwift

class MLOfflineViewController: ASViewController<ASTableNode> {
    
    let tableNode = ASTableNode()
    
    //private var tracks: [Track] = []
    
    //private let realm = try! Realm()
    
    //private var tracksRef: ThreadSafeReference<Results<Track>>!
    private var tracksobject_ids: [String] = []
    
    init() {
        super.init(node: self.tableNode)
        
        //self.aa_createSearchBar()
        
        self.tableNode.view.separatorStyle = .none
        self.tableNode.view.keyboardDismissMode = .onDrag
        
        
        self.tableNode.dataSource = self
        self.tableNode.delegate = self
        self.tableNode.backgroundColor = .navBar
  
        let realm = try! Realm()
        let localTracks = realm.objects(Track.self)
        self.tracksobject_ids = localTracks.map({ $0.object_id })
        
        //self.tracks = Array(localTracks)
        self.tableNode.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Offline"
        
        // self.fetchTracks()
    }
}

extension MLOfflineViewController: ASTableDataSource, ASTableDelegate {
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return tracksobject_ids.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        guard self.tracksobject_ids.count > indexPath.row else { return { ASCellNode() } }
        
        
        let object_id = self.tracksobject_ids[indexPath.row]
        
        let trackBlock = { () -> ASCellNode in
            guard let realm = try? Realm(), let track = realm.object(ofType: Track.self, forPrimaryKey: object_id) else {
                return ASCellNode()
            }
            
            let ref = ThreadSafeReference(to: track)
            
            guard let resolved = realm.resolve(ref) else {
                return ASCellNode()
            }
            
            let node = MusicLibraryViewNode(type: .tracks, data: resolved, scaleFactor: 0.5)
            node.delegate = self
            return node
        }
        
        return trackBlock //{ ASCellNode() }
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        guard let realm = try? Realm() else {
            return
        }
        
        var tracks: [Track] = []
        
        for object_id in self.tracksobject_ids {
            guard let track = realm.object(ofType: Track.self, forPrimaryKey: object_id) else {
                continue
            }
            
            let ref = ThreadSafeReference(to: track)
            
            guard let resolved = realm.resolve(ref) else {
                continue
            }
            
            tracks.append(Track(value: resolved, schema: .shared()))
        }
        
        Utils.updatePlayer(allTracks: tracks,
                           index: indexPath.row,
                           commonNavigation: self.commonNavigation)
    }
    
}

extension MLOfflineViewController: PrimitiveSelection {
    func onSelected(object: Any?) {
        
        
        if object is Track {
            let object = object as! Track
            
           
//            let ref = ThreadSafeReference(to: object)
//
//            guard let realm = try? Realm() else {
//                return
//            }
//
//            guard let globalResolve = realm.resolve(ref) else {
//                return
//            }
//
//
//            let object_id = globalResolve.object_id
//            print(object_id)

            
           
            
//            DispatchQueue.main.async {
//                guard let realm = try? Realm(), let resolved = realm.resolve(ref) else {
//                    return
//                }
//                Utils.displayOptions(for: resolved, controller: self)
//            }
            
            
        }
    }
}
