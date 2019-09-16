//
//  SearchResult.swift
//  SeshRadio
//
//  Created by spooky on 9/7/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation

enum SearchResultType: Decodable, CaseIterable {
    case member
    case album
    case song
    case notSupported
    
    init(from decoder: Decoder) throws {
        let label = try decoder.singleValueContainer().decode(String.self)
        switch label {
        case "member": self = .member
        case "album": self = .album
        case "song": self = .song
        default: self = .notSupported
        }
    }
    
    init(from string: String) throws {
        switch string {
        case "member": self = .member
        case "album": self = .album
        case "song": self = .song
        default: self = .notSupported
        }
    }
}

struct SearchResult: Decodable {
    var type: SearchResultType!
    
    var base: Any!
    
    /* Model's keys */
    private enum CodingKeys: String, CodingKey {
        case type
        case object
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(SearchResultType.self, forKey: .type)
        
        self.type = type
        
        switch type {
        case .member:
            self.base = try container.decode(Member.self, forKey: .object)
        case .album:
            self.base = try container.decode(Album.self, forKey: .object)
        case .song:
            self.base = try container.decode(Track.self, forKey: .object)
        default:
            print("not supported")
        }
    }
}
