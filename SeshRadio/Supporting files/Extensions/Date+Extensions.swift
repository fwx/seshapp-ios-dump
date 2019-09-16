//
//  Date+Extensions.swift
//  SeshRadio
//
//  Created by spooky on 12/15/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import Foundation

extension Date {
    func strWithFormat(_ format: String = "dd MMM YY - HH:mm") -> String {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = format
        outputFormatter.timeZone = TimeZone.current
        outputFormatter.locale = Locale.current
        
        return outputFormatter.string(from: self)
    }
    
    
}
