//
//  FeedModels.swift
//  SeshRadio
//
//  Created by spooky on 9/3/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import IGListKit

class FeedTours {
    var tours: [Tour] = []
    var identifier = "tours"
    
    init(tours: [Tour]) {
        self.tours = tours
    }
}

extension FeedTours: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.identifier as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
    
    
}

class FeedString {
    var base: String
    
    init(_ base: String) {
        self.base = base
    }
}

extension FeedString: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.base as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? FeedString else {
            return false
        }
        
        return self.base == object.base
    }
}
