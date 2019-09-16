//
//  SearchService.swift
//  SeshRadio
//
//  Created by spooky on 9/7/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class SearchService {
    static func search(query: String) -> Single<ArrayResponse<SearchResult>> {
        return API
            .shared
            .request(method: .search, params: ["search" : query], httpMethod: .get)
            .map({ (input, _) -> ArrayResponse<SearchResult> in
                return try API.shared.map(input)
            })
    }
}
