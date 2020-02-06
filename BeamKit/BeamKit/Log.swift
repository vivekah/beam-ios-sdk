//
//  Log.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 9/25/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import Foundation

class BKLog {
    enum Level: Int {
        case debug //🍋✳️
        case info //✳️💡🛎
        case warning //🔮🔫☔️☄️
        case error //🚫🔫
        case critical //🆘🚨
        case exception //🌈💣
    }
    
    // 🍋🎾🏐🚨☎️🔫🔮🛎💣💊🔓🔒✅🚫🆘✳️🔵🔔🥑🍎🌈☔️☄️💡🌐ℹ️🔷🚀🏆🥃🍞🌝🙈
    
    static var logLevel: BKLog.Level = .debug
    
    class func debug(_ message: AnyObject) {
        guard BKLog.logLevel.rawValue <= BKLog.Level.debug.rawValue else { return }
        let fullMessage = "🍋 DEBUG: " + message.description
        
        print(fullMessage)
    }
    
    class func debug(_ message: String) {
        guard BKLog.logLevel.rawValue <= BKLog.Level.debug.rawValue else { return }
        let fullMessage = "🍋 DEBUG: " + message
        
        print(fullMessage)
    }
    
    class func info(_ message: AnyObject) {
        guard BKLog.logLevel.rawValue <= BKLog.Level.info.rawValue else { return }
        let fullMessage = "✳️ INFO: " + message.description
        
        print(fullMessage)
    }
    
    class func info(_ message: String) {
        guard BKLog.logLevel.rawValue <= BKLog.Level.info.rawValue else { return }
        let fullMessage = "✳️ INFO: " + message
        
        print(fullMessage)
    }
    
    class func warning(_ message: AnyObject) {
        guard BKLog.logLevel.rawValue <= BKLog.Level.warning.rawValue else { return }
        let fullMessage = "☔️💧 WARNING: " + message.description
        
        print(fullMessage)
    }
    
    class func warning(_ message: String) {
        guard BKLog.logLevel.rawValue <= BKLog.Level.warning.rawValue else { return }
        let fullMessage = "☔️💧 WARNING: " + message
        
        print(fullMessage)
    }
    
    class func error(_ message: AnyObject) {
        guard BKLog.logLevel.rawValue <= BKLog.Level.error.rawValue else { return }
        let fullMessage = "🚫🔫 ERROR: " + message.description
        
        print(fullMessage)
    }
    
    class func error(_ message: String) {
        guard BKLog.logLevel.rawValue <= BKLog.Level.error.rawValue else { return }
        let fullMessage = "🚫🔫 ERROR: " + message
        
        print(fullMessage)
    }
    
    class func critical(_ message: AnyObject) {
        guard BKLog.logLevel.rawValue <= BKLog.Level.critical.rawValue else { return }
        let fullMessage = "🆘🚨 CRITICAL: " + message.description
        
        print(fullMessage)
    }
    
    class func critical(_ message: String) {
        guard BKLog.logLevel.rawValue <= BKLog.Level.critical.rawValue else { return }
        let fullMessage = "🆘🚨 CRITICAL: " + message
        
        print(fullMessage)
    }
    
    class func exception(_ message: AnyObject) {
        guard BKLog.logLevel.rawValue <= BKLog.Level.exception.rawValue else { return }
        let fullMessage = "🌈💣 EXCEPTION: " + message.description
        print(fullMessage)
    }
    
    class func exception(_ message: String) {
        guard BKLog.logLevel.rawValue <= BKLog.Level.exception.rawValue else { return }
        let fullMessage = "🌈💣 EXCEPTION: " + message
        print(fullMessage)
    }
}
