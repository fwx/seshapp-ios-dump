//
//  NewsService.swift
//  SeshRadio
//
//  Created by spooky on 12/15/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

class NewsService {
    static func fetchNews(count: Int = 10,
                          offset: Int = 0) -> Single<ArrayResponse<News>> {
        let params: [String : Any] = [ "limit" : count, "offset" : offset]
        
        return API.shared.request(method: .news, params: params, httpMethod: .get)
            .map({ (input, _) -> ArrayResponse<News> in
                return try API.shared.map(input)
            })
    }
    
    // Search news
}

extension NewsService {
    enum NewsSort: String {
        // news
        case category = "category"
        case text = "text"
        case title = "title"
        case tags = "tags"
        case id = "id"
    }
}
