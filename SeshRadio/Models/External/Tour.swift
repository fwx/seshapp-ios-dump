//
//  Tour.swift
//  SeshRadio
//
//  Created by spooky on 12/16/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import Foundation
import SwiftDate

struct Tour: Decodable {
    /* Model's properties */
    var object_id: String!
    private var image: String?
    private var image_sm: String?
    var name: String!
    private var link: String!
    private var changed: String!
    var events: [TourEvent] = []
    
    /* Model's keys */
    private enum CodingKeys: String, CodingKey {
        case object_id
        case image
        case image_sm
        case name
        case link
        case changed
        case events
    }
    
    /* Internal Getters */
    var imageUrl: URL? {
        return URL(string: self.image ?? "")
    }
    
    var smallImageUrl: URL? {
        return URL(string: self.image_sm ?? "")
    }
    
    var linkUrl: URL? {
        return URL(string: self.link)
    }
    
    var changedDate: DateInRegion? {
        return self.changed.toISODate()?.convertTo(region: Globals.currentRegion)
    }
}
