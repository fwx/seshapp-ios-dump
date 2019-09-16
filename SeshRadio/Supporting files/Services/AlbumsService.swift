//
//  AlbumsService.swift
//  SeshRadio
//
//  Created by spooky on 7/15/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import RxSwift

class AlbumsService {
    static func fetchAlbums(search: String? = nil,
                            limit: Int = 20,
                            offset: Int = 0) -> Single<ArrayResponse<Album>> {
        
        var params: [String: Any] = [ "limit" : limit,
                                      "offset": offset ]
        
        if let search = search {
            params["search"] = search
        }
        
        
        return API.shared
            .request(method: .albums, params: params, httpMethod: .get)
            .map({ (input, _) -> ArrayResponse<Album> in
                return try API.shared.map(input)
            })
    }
    
    static func fetchAlbum(_ album: String) -> Single<Album> {
        return API.shared
            .request(method: .albumsDetailed, params: ["object_id" : album], httpMethod: .get)
            .map({ (input, _) -> Album in
                return try API.shared.map(input)
            })
    }
    
    static func fetchTracks(for object_id: String) -> Single<Album> {
        return API
            .shared
            .request(method: .albumsDetailed,
                     params: ["object_id" : object_id],
                     httpMethod: .get)
            .map({ (input, _) -> Album in
                return try API.shared.map(input)
            })
    }
    
    static func fetchAlbumsFor(artistobject_id: String,
                               limit: Int = 20,
                               offset: Int = 0) -> Single<ArrayResponse<Album>> {
        
        let params: [String: Any] = [ "limit" : limit,
                                      "offset": offset,
                                      "artists__name" : artistobject_id]
        
        return API
            .shared
            .request(method: .albums,
                     params: params,
                     httpMethod: .get)
            .map({ (input, _) -> ArrayResponse<Album> in
                return try API.shared.map(input)
            })
    }
}
