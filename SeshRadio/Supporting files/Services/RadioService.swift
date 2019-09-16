//
//  RadioService.swift
//  SeshRadio
//
//  Created by spooky on 12/15/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire

import RxSwift

class RadioService {
    static func fetchStations() -> Single<ArrayResponse<Station>> {
        return API
            .shared
            .request(method: .stations)
            .map({ (input, serverResponse) -> ArrayResponse<Station> in
              return try API.shared.map(input)
            })
    }
    
    static func fetchTracks(for object_id: String,
                            limit: Int = 10,
                            offset: Int = 0) -> Single<ArrayResponse<HistoryEntity>> {
        return API
            .shared
            .request(method: .stationsHistory,
                     params: [
                        "object_id" : object_id,
                        "limit" : limit,
                        "offset" : offset
                ])
            .map({ (input, serverResponse) -> ArrayResponse<HistoryEntity> in
                return try API.shared.map(input)
            })
    }
}
