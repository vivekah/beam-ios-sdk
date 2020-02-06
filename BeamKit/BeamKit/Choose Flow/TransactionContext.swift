//
//  TransactionContext.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 9/27/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import Foundation

class TransactionContext {
    class func beginTransaction(at storeID: Int,
                                for spend: Float,
                                _ completion: ((Transaction?, BeamError) -> Void)? = nil) {
        guard let _ = BeamKitContext.shared.userID else {
            completion?(nil, .invalidUser)
            return
        }

        NonprofitAPI.getNonprofits(at: storeID) { storeNonprofits, error in
            guard let store = storeNonprofits else {
                completion?(nil, error)
                return
            }
            
            let transaction = Transaction(storeNon: store, amount: spend)
            completion?(transaction, .none)
        }
    }
    
    
}
