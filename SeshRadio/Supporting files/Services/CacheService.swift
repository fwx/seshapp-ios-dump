//
//  CacheService.swift
//  SeshRadio
//
//  Created by spooky on 7/16/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import RealmSwift

class CacheService {
    static let instance = CacheService()
    
    func saveToCache(item: CachableAVItem? = nil, track: Track, data: Data) {
        let file = getPathForTrack(by: track.object_id)
        
        DispatchQueue.global().async {
            // try? data.write(to: file)
            
            do {
                try data.write(to: file)
                //let ref = ThreadSafeReference(to: track)
                
                DispatchQueue.main.async {
                    self.saveToRealmCache(track: track, path: file.absoluteString)
                }
                
            } catch {
                print(error)
            }
        }
    }
    
    func getPathForTrack(by id: String) -> URL {
        let file = getDocumentsDirectory().appendingPathComponent(String(format: "music/%@.mp3", id))
        
        return file
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveToRealmCache(track: Track, path: String) {
        let realm = try! Realm()
        
        
        track.localPath = path
        
        try! realm.write {
            realm.add(track, update: .all)
        }
    }
    
    func isCached(trackId: String) -> Bool {
        let realm = try! Realm()
        
        
        if realm.object(ofType: Track.self, forPrimaryKey: trackId) != nil {
            return true
        } else {
            return false
        }
    }
    
    func deleteFromCache(track: Track, realm: Realm) {
        fatalError("not implemented")
//        guard let cachedTrack = realm.objects(RMSongInfo.self).filter("track_id=%@", track.getId()).first else { return }
//        let fileUrl = Utils.getPathForTrack(by: track.getId())
//
//        do {
//            try FileManager.default.removeItem(at: fileUrl)
//            try realm.write {
//                realm.delete(cachedTrack)
//            }
//        } catch {
//            print(error)
//        }
    }

}
