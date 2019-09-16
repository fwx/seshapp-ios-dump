//
//  ShowsService.swift
//  SeshRadio
//
//  Created by spooky on 12/15/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire

import RxSwift

class ShowsService {
    static func fetchShows() -> Single<ArrayResponse<Tour>> {
        return API.shared.request(method: .tours, params: ["limit" : 10], httpMethod: .get)
            .map({ (input, _) -> ArrayResponse<Tour> in
                return try API.shared.map(input)
                
            })
    }
}
