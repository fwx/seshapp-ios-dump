//
//  TeamSection.swift
//  SeshRadio
//
//  Created by spooky on 12/16/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import Foundation
import IGListKit

class TeamSection {
    fileprivate var members: [Member] = []
    
    init(members: [Member]) {
        self.members = members
    }
    
    func getMembers() -> [Member] { return self.members }
    func getMember(by index: Int) -> Member { return self.members[index] }
}

extension TeamSection: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return "team" as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? TeamSection else { return false }
        return self === object
    }
}
