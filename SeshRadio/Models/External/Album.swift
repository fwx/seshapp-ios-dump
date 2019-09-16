//
//  Album.swift
//  SeshRadio
//
//  Created by spooky on 12/22/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import Foundation
import IGListKit
import SwiftDate

class Album: Decodable {
    /* Model's properties */
    var object_id: String!
    private var album_cover: String!
    private var album_cover_sm: String!
    private var songs_amount: Int!
    private var artists_concated: String!
    var songs: [Track]? = []
    var title: String!
    var year: Int!
    private var changed: String!
    
    
    /* Model's keys */
    private enum CodingKeys: String, CodingKey {
        case object_id
        case album_cover
        case album_cover_sm
        case songs_amount
        case artists_concated
        case title
        case year
        case changed
        case songs
    }
    
    /* Internal Getters */
    var albumCover: URL? {
        return URL(string: self.album_cover ?? "")
    }
    
    var smallAlbumCover: URL? {
        return URL(string: self.album_cover_sm ?? "")
    }
    
    var songsAmount: Int {
        return self.songs_amount
    }
    
    var artistsConcated: String {
        return self.artists_concated
    }
    
    var changedDate: DateInRegion? {
        return self.changed.toISODate()?.convertTo(region: Globals.currentRegion)
    }
    
    
   
    
    
}

extension Album: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.object_id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Album else { return false }
        
        return object.artistsConcated == self.artistsConcated
            && object.year == self.year
    }
    
    
}
