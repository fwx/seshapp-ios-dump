//
//  LogBuilder.swift
//  OEApp
//
//  Created by spooky on 6/10/19.
//  Copyright © 2019 feip. All rights reserved.
//

import Foundation
import Sentry

class LogBuilder {
    private var errorParams: [String : Any] = [:]
    private var errorMessage: String = ""
    
    init() { }
    
    func setMessage(_ message: String) -> LogBuilder {
        self.errorMessage = message.uppercased()
        
        return self
    }
    
    @discardableResult
    func appendParams(key: String, value: Any) -> LogBuilder {
        self.errorParams[key] = value
        
        
        return self
    }
    
    @discardableResult
    func send(with level: SentrySeverity = .debug) -> LogBuilder {
        let event = Event(level: level)
        
        event.message = self.errorMessage
        event.extra = self.errorParams
        
        Client.shared?.send(event: event, completion: nil)
        
        return self
    }
}
