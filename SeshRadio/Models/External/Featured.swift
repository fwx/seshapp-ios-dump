//
//  Featured.swift
//  SeshRadio
//
//  Created by spooky on 12/22/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import Foundation
import SwiftDate

struct Featured: Decodable {
//    private var picture: String!
//    private var title: String!
//    private var sub_title: String?
//    private var songs: [Track]!
//
//    func getPicture() -> URL? { return URL(string: self.picture) }
//    func getTitle() -> String { return self.title! }
//    func getSubtitle() -> String? { return self.sub_title }
//    func getTracks() -> [Track] { return self.songs }
    
    /* Model's properties */
    var object_id: String!
    private var picture: String?
    private var picture_sm: String?
    private var songs_amount: Int!
    var title: String!
    var songs: [Track]? = []
    private var sub_title: String!
    private var changed: String!
    
    
    /* Model's keys */
    private enum CodingKeys: String, CodingKey {
        case object_id
        case picture
        case picture_sm
        case songs_amount
        case title
        case sub_title
        case changed
        case songs
    }
    
    /* Internal's Getters */
    var pictureUrl: URL? {
        return URL(string: self.picture ?? "")
    }
    
    var smallPictureUrl: URL? {
        return URL(string: self.picture_sm ?? "")
    }
    
    var songsAmount: Int {
        return self.songs_amount
    }
    
    var subTitle: String {
        return self.sub_title
    }
    
    var changedDate: DateInRegion? {
        return self.changed.toISODate()?.convertTo(region: Globals.currentRegion)
    }
    
}

extension Featured {
    mutating func setImage(image: String) { self.picture = image }
}


