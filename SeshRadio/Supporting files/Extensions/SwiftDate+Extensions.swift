//
//  SwiftDate+Extensions.swift
//  SeshRadio
//
//  Created by spooky on 8/18/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import SwiftDate

extension DateInRegion {
    var asLocalDate: DateInRegion? {
        return self.convertTo(region: Globals.currentRegion)
    }
}
