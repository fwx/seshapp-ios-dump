//
//  TeamService.swift
//  SeshRadio
//
//  Created by spooky on 12/15/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire

import RxSwift

class TeamService {
    static func fetchMembers(limit: Int = 10) -> Single<ArrayResponse<Member>> {
        
        var params: [String: Any] = ["limit" : limit]
        
        
        return API.shared.request(method: .members, params: params)
            .map({ (input, serverData) -> ArrayResponse<Member> in
                return try API.shared.map(input)
            })
        
    }
    
    static func fetchMember(_ member: String) -> Single<Member> {
        return API.shared.request(method: .membersDetailed)
            .map({ (input, serverData) -> Member in
                return try API.shared.map(input)
            })
        
    }
}
