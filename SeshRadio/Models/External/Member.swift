//
//  Member.swift
//  SeshRadio
//
//  Created by spooky on 12/15/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import Foundation
import DifferenceKit

class Member: Decodable {
    /* Model's properties */
    var object_id: String!
    private var avatar: String?
    private var avatar_sm: String?
    var role: String!
    var name: String!
    var links: [Link] = []
    
    /* Model's keys */
    private enum CodingKeys: String, CodingKey {
        case object_id
        case avatar
        case avatar_sm
        case role
        case name
        case links
    }
    
    /* Internal Getters */
    var avatarUrl: URL? {
        return URL(string: self.avatar ?? "")
    }
    
    var smallAvatarUrl: URL? {
        return URL(string: self.avatar_sm ?? "")
    }
}

extension Member: Differentiable {
    var differenceIdentifier: String {
        return self.object_id
    }
    
    func isContentEqual(to source: Member) -> Bool {
        return source.name == self.name
        && source.role == self.role
    }
}
