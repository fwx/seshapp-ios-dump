//
//  News.swift
//  SeshRadio
//
//  Created by spooky on 12/15/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import Foundation
import SwiftDate
import IGListKit

enum NewsCategory: String, Decodable {
    case release
    case tour
    case stream
    case unknown
    // ToDo
}

class News: Decodable {
    /* Model's properties */
    var object_id: String!
    var title: String!
    var text: String!
    var tags: [String] = []
    var category: NewsCategory?
    private var image: String?
    private var image_sm: String?
    private var link: String!
    private var changed: String!
    
    /* Model's keys */
    private enum CodingKeys: String, CodingKey {
        case object_id
        case title
        case text
        case category
        case image
        case image_sm
        case link
        case changed
    }
    
    /* Internal Getters */
    var imageUrl: URL? {
        return URL(string: self.image ?? "")
    }
    
    var smallImageUrl: URL? {
        return URL(string: self.image_sm ?? "")
    }
    
    var linkUrl: URL? {
        return URL(string: self.link ?? "")
    }
    
    var changedDate: DateInRegion? {
        return self.changed.toISODate()?.convertTo(region: Globals.currentRegion)
    }
}

// IGListKit
extension News: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.object_id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? News else { return false }
        return object.object_id == self.object_id
            && object.changedDate?.timeIntervalSince1970 == self.changedDate?.timeIntervalSince1970
    }
}
