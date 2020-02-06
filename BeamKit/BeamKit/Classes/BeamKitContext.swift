//
//  BeamKitContext.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 9/25/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import Foundation

enum BKEnvironment {
    case production
    case staging
}

class BeamKitContext {
    static let shared = BeamKitContext()
    
    private(set) var userID: String? = nil
    lazy var userAPI: BeamKitUserAPI = .init()
    lazy var nonprofits: [Nonprofit] = .init() // todo figure ordering
    
    var token: String? = nil
    
    func register(with key: String, environment: BKEnvironment) {
        self.token = key
        Network.shared.environment = environment
    }
    
    func registerUser(id: String?,
                      info: JSON?,
                      _ completion: ((String?, BeamError) -> Void)? = nil) {
        if let id = id {
            //TODO: test if need to clear out user/ data
            userID = id
            BKLog.debug("Beam Registered User with id \(id)")
            completion?(userID, .none)
            return
        }
            
        userAPI.registerUser(options: info, completion)
    }
    
}
