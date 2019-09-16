//
//  TourEvent
//  SeshRadio
//
//  Created by spooky on 12/16/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import Foundation
import SwiftDate

struct TourEvent: Decodable {
    /* Model's properties */
    var id: Int!
    var date: String!
    private var link: String!
    var place: String!
    private var from_tour: String? // object_id
    
    /* Model's keys */
    private enum CodingKeys: String, CodingKey {
        case id
        case date
        case link
        case place
        case from_tour
    }
    
    /* Internal Getters */
    
    var linkUrl: URL? {
        return URL(string: self.link ?? "")
    }
    
    var fromTourobject_id: String? {
        return self.from_tour
    }
}
