//
//  Station.swift
//  SeshRadio
//
//  Created by spooky on 12/15/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import Foundation


class StationPlaylist: Decodable {
    var title: String! = ""
    private var picture: String! = ""
    var current_song: Track!
    
    required init() { }
    
    var pictureUrl: URL? {
        get {
            return URL(string: self.picture)
        }
    }
}
class Station: Decodable {
    /* Model's properties */
    var object_id: String!
    var title: String!
    private var logo: String?
    private var logo_sm: String?
    private var sub_title: String!
    private var stream_url: String!
    private var stream_info_url: String!
    private var current_song: Track!
    
    /* Model's keys */
    private enum CodingKeys: String, CodingKey {
        case object_id
        case logo
        case logo_sm
        case title
        case sub_title
        case stream_url
        case stream_info_url
        case current_song
    }
    
    /* Internal Getters */
    var subTitle: String! {
        return self.sub_title
    }
    
    var logoUrl: URL? {
        return URL(string: self.logo ?? "")
    }
    
    var logoSmallUrl: URL? {
        return URL(string: self.logo_sm ?? "")
    }
    
    var streamUrl: URL? {
        return URL(string: self.stream_url)
    }
    
    var streamInfoUrl: URL? {
        return URL(string: self.stream_info_url)
    }
    
    var currentSong: Track! {
        return self.current_song
    }
    
    
}
