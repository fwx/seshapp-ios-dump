//
//  HistoryEntity.swift
//  SeshRadio
//
//  Created by spooky on 8/18/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import SwiftDate

class HistoryEntity: Decodable {
//    "start_time": "2019-08-18T02:55:24.012914Z",
//    "end_time": "2019-08-18T02:58:41.603114Z",
    
    /* Model's properties */
    private var start_time: String!
    private var end_time: String!
    var song: Track!
    var object_id: String!
    
    /* Model's keys */
    private enum CodingKeys: String, CodingKey {
        case start_time
        case end_time
        case song
        case object_id
    }
    
    /* Internal Getters */
    var startTime: DateInRegion? {
        return self.start_time.toISODate()
    }
    
    var endTime: DateInRegion? {
        return self.end_time.toISODate()
    }
}
