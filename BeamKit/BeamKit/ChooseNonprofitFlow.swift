//
//  ChooseNonprofitFlow.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 9/26/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import Foundation
import UIKit

// TODO should I move?
//extension UIViewController {
//    // TODO COM BSCK
//    public func presentTransactionFull(at storeID: String,
//                                for spend: Float,
//                                with completion: ((BeamError?) -> Void)? = nil) {
//        
//        TransactionContext.beginTransaction(at: storeID, for: spend) { transaction, error in
//            guard let transaction = transaction,
//                    error == .none else {
//                        completion?(error)
//                        return
//            }
//            let vc = ChooseNonprofitVC(with: transaction)
//            DispatchQueue.main.async {
//                self.present(vc, animated: true) {
//                    completion?(BeamError.none)
//                }
//            }
//        }
//    }
//    
//    public func pushTransactionFull(at storeID: String,
//                             for spend: Float,
//                             with completion: ((BeamError?) -> Void)? = nil) {
//        guard let navVC = self.navigationController else {
//            completion?(.invalidConfiguration)
//            return
//        }
//        TransactionContext.beginTransaction(at: storeID, for: spend) { transaction, error in
//            var error = error
//            defer {
//                completion?(error)
//            }
//            guard let transaction = transaction,
//                error == .none else { return }
//            let vc = ChooseNonprofitVC(with: transaction)
//            DispatchQueue.main.async {
//                navVC.pushViewController(vc, animated: true)
//            }
//        }
//    }
//}


class ChooseNonprofitFlow {
    
}
