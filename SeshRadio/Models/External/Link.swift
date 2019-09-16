//
//  Link.swift
//  SeshRadio
//
//  Created by spooky on 12/15/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import Foundation
import IGListKit

class Link: Decodable {
    var type: String!
    var link: String!
    
    required init() { }
    
    func getType() -> String { return self.type }
    func getLink() -> URL? { return URL(string: self.link) }
}

extension Link: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.link as NSObjectProtocol
    }
    
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Link else { return false }
        
        return object.getLink() == self.getLink() && object.getType() == self.type
    }
    
    
}

extension Link: Equatable {
    static func == (lhs: Link, rhs: Link) -> Bool {
        return lhs.getLink() == rhs.getLink() && rhs.getType() == lhs.getType()
    }
}
