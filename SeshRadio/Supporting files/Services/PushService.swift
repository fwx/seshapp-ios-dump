//
//  PushService.swift
//  SeshRadio
//
//  Created by spooky on 9/8/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import RxSwift

class PushService {
    private static func generateVersion() -> [String: String] {
        let version = Bundle
            .main
            .infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
        
        
        return [
            "device" : "ios",
            "version" : version
        ]
    }
    
    static func registerToken(_ token: String) -> Completable {
        var params = PushService.generateVersion()
        params["push_token"] = token
        
        return API
            .shared
            .request(method: .push,
                     params: params,
                     httpMethod: .post)
            .asCompletable()
    }
}
