//
//  MusicService.swift
//  SeshRadio
//
//  Created by spooky on 12/22/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import Foundation
import IGListKit

import RxSwift

class MusicService {
    
    static func fetchArtists(limit: Int = 20, offset: Int = 0) -> Single<ArrayResponse<Member>> {
        return TeamService
            .fetchMembers(limit: limit)
        
    }

    static func fetchTracks(search: String? = nil,
                            limit: Int = 100,
                            offset: Int = 0) -> Single<ArrayResponse<Track>> {
        var params: [String: Any] = [ "limit" : limit,
                                      "offset": offset ]
        
        if let search = search {
            params["search"] = search
                .addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
        }
        
        
        return API
            .shared
            .request(method: .tracks, params: params, httpMethod: .get)
            .map({ (input, _) -> ArrayResponse<Track> in
                return try API.shared.map(input)
            })
    }
}

extension MusicService {
    static func searchTracks(query: String) -> Single<ArrayResponse<Track>> {
        return self.fetchTracks(search: query)
    }
}

extension MusicService {
    enum ArtistSort: String {
        case date
        case lastChanged = "last_changed"
        case name
        case photo
    }
    
    enum AlbumSort: String {
        case date
        case lastChanged = "last_changed"
        case title
        case fullTitle = "full_title"
        case artistStr = "artist_str"
        case year
        case albumCover = "album_cover"
    }
    
  
}
