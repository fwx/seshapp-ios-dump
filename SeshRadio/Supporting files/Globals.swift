//
//  Globals.swift
//  SeshRadio
//
//  Created by spooky on 12/15/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import Foundation
import UIKit
import SwiftDate

typealias Artist = Member

class Globals {
    static let kUserAgent = "SESHapp-iOS"
    
    static let dateFormatter = DateFormatter()
    static let currentRegion = Region(calendar: Calendars.gregorian,
                                      zone: TimeZone.current,
                                      locale: Locale.current)
    
    
    struct API {
        //dev_sapi.teamse.sh
        static let kBaseUrl = ""
        static let kApiUrl = ""
        
        static let kApiToken = ""
    }
    
    struct Strings {
        static let PLAYER_TITLE = "TeamSESH @ Radio"
        static let SHARE_FORMAT = "Listening %@ on #SESHapp"
        static let WATCH_STREAM = "Check out LIVE on #SESHapp"
    }
    
    struct Controllers {
        static let kSearchResultController = "SearchResultsController"
    }
    
    enum MLSearchType {
        case tracks
        case albums
        case artists
    }
    
    enum CurrentPlayer {
        case radio
        case player
    }
    
    struct SettingsBundleKeys {
        static let autoCache = "auto_cache_tracks"
    }
    
    static let META_DATA = "timedMetadata"
    
    static var automaticallyCacheTracks = true
    
    static let currentPlayer: CurrentPlayer = .player
    
    fileprivate static var colors: [UIColor] = [ UIColor(netHex: 0x0062A7),
                                                 UIColor(netHex: 0xA74B00),
                                                 UIColor(netHex: 0x52A700),
                                                 UIColor(netHex: 0xb40076) ]
    
    static func getRandomColor() -> UIColor {
        let rndIndex = arc4random_uniform(UInt32(colors.count - 1)) + 0
        
        return colors[Int(rndIndex)]
    }
    
    static let kFakeTrack = Track(object_id: "not_playing",
                                  trackPath: "",
                                  albumTitle: "not playing",
                                  trackCover: nil,
                                  trackCoverSm: nil,
                                  artistsCon: "not playing",
                                  trackNumber: 0,
                                  trackYear: 2007,
                                  changed: "",
                                  release: true,
                                  album: nil,
                                  artists: [],
                                  single: true,
                                  title: "not playing", bitrate: 0, duration: 0, size: 0)
}


enum LoadingState: Int {
    case none = -1
    case loading = 0
    case loaded = 1
    case error = 2
}


@objc protocol PrimitiveSelection: class {
    @objc optional func onSelected(object: Any?)
}

@objc protocol ShareProtocol: class {
    @objc optional func onShare(object: Any)
}
