//
//  MediaInfoHelper.swift
//  SeshRadio
//
//  Created by spooky on 5/5/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import MediaPlayer

class MediaInfoHelper {
    static let shared = MediaInfoHelper()
    
    private var nowPlayingInfo = [String: Any]()
    
    var track: Track! = nil {
        didSet {
            nowPlayingInfo[MPMediaItemPropertyTitle] = track.title
            nowPlayingInfo[MPMediaItemPropertyArtist] = track.artistsConcacted
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = track.duration //playerItem.asset.duration.seconds
            //nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate

            
            self.triggerUpdate()
        }
    }
    
    var isRadio = false {
        didSet {
            // switch delegates?
            nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = isRadio
            self.triggerUpdate()
        }
    }
    
    var currentTime: Double = 0 {
        didSet {
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
            self.triggerUpdate()
        }
    }
    
    init() {
        //nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = true
    }
    
}

extension MediaInfoHelper {
    private func triggerUpdate() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}
