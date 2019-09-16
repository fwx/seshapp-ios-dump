//
//  ArrayResponse.swift
//  SeshRadio
//
//  Created by spooky on 7/14/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation

struct ArrayResponse<T: Decodable>: Decodable {
    var count: Int!
    var next: String?
    var previous: String?
    
    var results: [T] = []
}
