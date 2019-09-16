//
//  FlatExtensions.swift
//  SeshRadio
//
//  Created by spooky on 1/15/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import CoreMedia

// a single class extensions

extension CMTime {
    var asFloat: Float {
        if !self.isValid {
            return 0
        }
        
        if !self.seconds.isFinite {
            return 0
        }
        
        return Float(CMTimeGetSeconds(self))

    }
}

extension Float {
    var asTime: String {
        let interval = Int(self)
        let formatter = Utils.dateCompsFormatter
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        
        return formatter.string(from: TimeInterval(interval)) ?? "0:00"
    }
}
