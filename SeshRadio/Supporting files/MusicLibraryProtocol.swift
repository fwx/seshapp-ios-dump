//
//  MusicLibraryProtocol.swift
//  SeshRadio
//
//  Created by spooky on 2/23/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation

@objc protocol MusicLibraryProtocol {
    @objc optional func onDataSelected(_ data: Any)
}
