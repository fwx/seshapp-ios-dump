//
//  PushHelper.swift
//  OEApp
//
//  Created by spooky on 6/3/19.
//  Copyright © 2019 feip. All rights reserved.
//

import Foundation
import RxSwift

class PushHelper {
    static let instance = PushHelper()
    
    enum PushType: String {
        case link
        case nullable
    }
    
    init() { }
    
    // Nullable is used to ignore the initialization of behavior subject
    var tappedPush = BehaviorSubject<PushType>(value: .nullable)
    var silentPush = BehaviorSubject<PushType>(value: .nullable)
    var latestData: Any?
    
    // Silent is used to refresh certain screens
    func acceptPush(by type: PushType, data: Any? = nil, silent: Bool = false) {
        self.latestData = data
        
        if silent {
            self.silentPush.onNext(type)
        } else {
            self.tappedPush.onNext(type)
        }
    }
    
    // helper func
    func acceptPush(by userInfo: [String: Any], silent: Bool = false) {
        if let link = userInfo["link"] as? String {
            self.acceptPush(by: .link, data: link, silent: silent)
        }
        
        // legacy
//        guard let rawType = userInfo["type"] as? String else {
//            return
//        }
        
        //
        //
        //        guard let pushType = PushType(rawValue: rawType) else {
        //            return
        //        }
        
        
        
//        var pushType: PushType = .nullable
//
//        if rawType.contains("group.") {
//            pushType = .addedToGroup
//        } else if rawType.contains("order") {
//            pushType = .orderUpdated
//        }
//
//        switch pushType {
//        case .addedToGroup:
//            guard let groupIdRaw = userInfo["group_id"] as? String,
//                let groupId = Int(groupIdRaw) else {
//                    return
//            }
//
//            self.acceptPush(by: pushType, data: groupId, silent: silent)
//
//        case .orderUpdated:
//            self.acceptPush(by: pushType, data: nil, silent: silent)
//        default:
//            print("not implemented")
//        }
    }
}
