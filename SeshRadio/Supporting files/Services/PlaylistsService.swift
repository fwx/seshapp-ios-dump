//
//  FeaturedService.swift
//  SeshRadio
//
//  Created by spooky on 7/15/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import RxSwift

class PlaylistsService {
    enum FeaturedSort: String {
        case date
        case lastChanged = "last_changed"
        case title
        case subTitle = "sub_title"
        case picture
    }
    
    enum TrackSort: String {
        case date
        case lastChanged = "last_changed"
        case title
        case fullTitle = "full_title"
        case artist = "artist_str"
        
        // search stuff
    }
    
    
    static func fetch(sortBy: FeaturedSort = .title,
                              sortKey: API.SortKey = .desc,
                              searchBy: FeaturedSort? = nil,
                              search: String? = nil,
                              limit: Int = 100,
                              offset: Int = 0) -> Single<ArrayResponse<Featured>> {
        var params: [String: Any] = [ "sort_by" : sortBy.rawValue,
                                      "sort_key" : sortKey.rawValue,
                                      "limit" : limit,
                                      "offset": offset ]
        
        if let search = search {
            params["search"] = search
        }
        
        if let searchBy = searchBy {
            params["search_by"] = searchBy.rawValue
        }
        
        return API.shared.request(method: .playlists, params: params, httpMethod: .get)
            .map({ (input, _) -> ArrayResponse<Featured> in
                return try API.shared.map(input)
            })
    }
    
    static func fetchTracks(for artist: String,
                            limit: Int = 100,
                            offset: Int = 0) -> Single<Featured> {
        let params = [
            "artist" : artist
        ]
        
        return API
            .shared
            .request(method: .playlistsDetailed,
                     params: params,
                     httpMethod: .get)
            .map({ (input, _) -> Featured in
                return try API.shared.map(input)
            })
    }
}
