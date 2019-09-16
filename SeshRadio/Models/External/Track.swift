//
//  SESHTrack.swift
//  SeshRadio
//
//  Created by spooky on 12/15/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import Foundation
import SwiftDate
import IGListKit
import RealmSwift
import Realm

class Track: Object, Decodable {
    /* Model's properties */
    
    @objc dynamic var object_id: String!
    @objc dynamic private var track_path: String!
    @objc dynamic private var album_title: String?
    @objc dynamic private var track_cover: String?
    @objc dynamic private var track_cover_sm: String?
    @objc dynamic private var artists_concated: String!
    @objc dynamic private var track_number: Int = 0
    @objc dynamic private var track_year: Int = 0
    @objc dynamic private var changed: String!
    @objc dynamic var trackRelease: Bool = false
    @objc dynamic var album: String?
    private let cachedArtists = List<String>()
    var artists: [String] {
        return Array(cachedArtists)
    }
    @objc dynamic var single: Bool = false
    @objc dynamic var title: String!
    @objc dynamic var bitrate: Int = 0
    @objc dynamic var duration: Float = 0
    @objc dynamic var size: Int = 0
    
    @objc dynamic var localPath: String = ""
    
    /* Model's keys */
    private enum CodingKeys: String, CodingKey {
        case object_id
        case track_path
        case album_title
        case track_cover
        case track_cover_sm
        case artists_concated
        case track_number
        case track_year
        case release
        case album
        case artists
        case single
        case title
        case bitrate
        case duration
        case size
        case changed
    }
    
    /* Internal Getters */
    
    var trackPath: URL! {
        return URL(string: self.track_path)
    }
    
    var albumTitle: String {
        return self.album_title ?? ""
    }
    
    var trackCover: URL? {
        return URL(string: self.track_cover ?? "")
    }
    
    var smallTrackCover: URL? {
        return URL(string: self.track_cover_sm ?? "")
    }
    
    var artistsConcacted: String {
        return self.artists_concated
    }
    
    var trackNumber: Int {
        return self.track_number
    }
    
    var trackYear: Int {
        return self.track_year
    }
    
    var changedDate: DateInRegion? {
        return self.changed.toISODate()?.convertTo(region: Globals.currentRegion)
    }
    

    override static func primaryKey() -> String? {
        return "object_id"
    }
    
    required init() {
        super.init()
    }
    
    convenience init(object_id: String,
                     trackPath: String,
                     albumTitle: String?,
                     trackCover: String?,
                     trackCoverSm: String?,
                     artistsCon: String,
                     trackNumber: Int,
                     trackYear: Int,
                     changed: String,
                     release: Bool,
                     album: String?,
                     artists: [String],
                     single: Bool,
                     title: String,
                     bitrate: Int,
                     duration: Float,
                     size: Int) {
        self.init()
        
        self.object_id = object_id
        self.track_path = trackPath
        self.album_title = albumTitle
        self.track_cover = trackCover
        self.track_cover_sm = trackCoverSm
        self.artists_concated = artistsCon
        self.track_number = trackNumber
        self.track_year = trackYear
        self.changed = changed
        self.trackRelease = release
        self.album = album
        self.cachedArtists.append(objectsIn: artists)
        self.single = single
        self.title = title
        self.bitrate = bitrate
        self.duration = duration
        self.size = size
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let object_id = try container.decode(String.self, forKey: .object_id)
        let trackPath = try container.decode(String.self, forKey: .track_path)
        let albumTitle = try? container.decode(String.self, forKey: .album_title)
        let trackCover = try container.decodeIfPresent(String.self, forKey: .track_cover)
        let trackSoverSm = try container.decodeIfPresent(String.self, forKey: .track_cover_sm)
        let artistsConcated = try container.decode(String.self, forKey: .artists_concated)
        let trackNumber = try container.decode(Int.self, forKey: .track_number)
        let trackYear = try container.decode(Int.self, forKey: .track_year)
        let changed = try container.decode(String.self, forKey: .changed)
        let release = try container.decode(Bool.self, forKey: .release)
        let album = try? container.decode(String.self, forKey: .album)
        let artists = try container.decode([String].self, forKey: .artists)
        let single = try container.decodeIfPresent(Bool.self, forKey: .single) ?? false
        let title = try container.decode(String.self, forKey: .title)
        let bitrate = try container.decode(Int.self, forKey: .bitrate)
        let duration = try container.decode(Float.self, forKey: .duration)
        let size = try container.decode(Int.self, forKey: .size)
        
        
        self.init(object_id: object_id,
                  trackPath: trackPath,
                  albumTitle: albumTitle,
                  trackCover: trackCover,
                  trackCoverSm: trackSoverSm,
                  artistsCon: artistsConcated,
                  trackNumber: trackNumber,
                  trackYear: trackYear,
                  changed: changed,
                  release: release,
                  album: album,
                  artists: artists,
                  single: single,
                  title: title,
                  bitrate: bitrate,
                  duration: duration,
                  size: size)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    override static func ignoredProperties() -> [String] {
        return ["artists"]
    }
    
//    private var track_path: String!
//    private var album_title: String!
//    private var track_cover: String?
//    private var track_cover_sm: String?
//    private var artists_concated: String!
//    private var track_number: Int!
//    private var track_year: Int!
//    private var changed: String!
}

extension Track: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.object_id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Track else { return false }
        
        return object.trackYear == self.trackYear
            && object.album == self.album
            && object.duration == self.duration
    }
    
    
}
