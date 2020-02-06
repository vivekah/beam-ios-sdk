//
//  TransactionAPI.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 9/27/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import Foundation

//class TransactionAPI {
//    class func beginTransaction(at storeID: String,
//                                for spend: Float,
//                                userID: String,
//                                _ completion: ((Transaction?, BeamError) -> Void)? = nil) {
//        // COULD DO : OPTIONAL PARAMS
//        // COULD DO MORE: error handling from backend
//        // TODO -- transaction endpoint two places, fix
//        
//        let body: JSON = ["store": storeID,
//                          "cart_total": spend,
//                          "user": userID]
//        
//        let successHandler: (JSON?) -> Void = {  transactionJSON in
//            BKLog.info("Did Register Nonprofit Selection")
//            guard let transaction_id = transactionJSON?["transaction"] as? String else {
//                BKLog.error("Invalid Nonprofit Selection Response")
//                completion?(nil, .networkError)
//                return
//            }
//            let trans = Transaction(with: storeID,
//                                    transactionID: transaction_id,
//                                    transAmt: spend,
//                                    multiplier: 1)
//            completion?(trans, .none)
//        }
//        
//        let errorHandler: (ErrorType) -> Void = { (error) in
//            BKLog.error("Nonprofit Selection Error \(error)")
//            completion?(nil, .networkError)
//        }
//        
//        Network.shared.post(urlPath: "transaction/",
//                            body: body,
//                            successJSONHandler: successHandler,
//                            errorHandler: errorHandler)
//    }
//    
//}
