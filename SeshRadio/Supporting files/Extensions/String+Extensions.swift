//
//  String+Extensions.swift
//  SeshRadio
//
//  Created by spooky on 1/10/19.
//  Copyright © 2019 lesovoy. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func createAttributed(fontSize: CGFloat = 16,
                          fontColor: UIColor = .white, additionalAttributed: [NSAttributedString.Key : Any] = [:]) -> NSAttributedString {
        
        var attributes = additionalAttributed
        attributes[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: fontSize)
        attributes[NSAttributedString.Key.foregroundColor] = fontColor
        
        return NSAttributedString(string: self, attributes: attributes)
    }
    
}
