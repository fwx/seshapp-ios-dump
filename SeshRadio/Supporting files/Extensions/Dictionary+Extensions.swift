//
//  Dictionary+Extensions.swift
//  SeshRadio
//
//  Created by spooky on 12/15/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import Foundation


extension Dictionary {
    var asStringParams: String {
        var _string = ""
        for (key, value) in self {
            _string.append("&\(key)=\(value)")
        }
        
        return _string
    }
}
