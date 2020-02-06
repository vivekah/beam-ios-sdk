//
//  Manager.swift
//  beam-ios-sdk
//
//  Created by ALEXANDRA SALVATORE on 6/26/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import Foundation

// TODO LOG MESSAGES FIX

class BKManager: NSObject {
    // register frameowrk func
    // register fonts in that func
    
    // TODO -- create custom options type???
    init(with key: String,
         environment: BKEnvironment,
         logLevel: BKLog.Level,
         options: JSON) {
        BKLog.logLevel = logLevel
        super.init()
        BeamKitContext.shared.register(with: key, environment: environment)
    }
    
    func registerUser(id: String?,
                      info: JSON?,
                      _ completion: ((String?, BeamError) -> Void)? = nil) {
        return BeamKitContext.shared.registerUser(id: id, info: info, completion)
    }
    
}


// TODOS MVP

// NICE TO HAVE
    // more discrete error handling 
