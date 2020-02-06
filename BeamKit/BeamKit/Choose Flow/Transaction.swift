//
//  Transaction.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 9/25/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import Foundation

//class Transaction {
//    let transactionID: String
//    let storeID: String
//    let transAmt: Float
//
//    let multiplier: Int
//    var isRedeemed: Bool = false
//
//    var nonprofits: [Nonprofit]? = nil
//    var lastNonprofit: Nonprofit? = nil
//    var storeName: String = ""
//    var baseDonation: Double = 0.0
//    var rectLogo: String? = nil
//    var logo: String? = nil
//    var percent: Double = 0.0
//
//    init(with storeID: String,
//         transactionID: String,
//         transAmt: Float,
//         multiplier: Int) {
//        self.storeID = storeID
//        self.transactionID = transactionID
//        self.transAmt = transAmt
//        self.multiplier = multiplier
//    }
//}

internal class Nonprofit: NSObject {
    var cause: String?
    let id: Int
    let missionDescription: String?
    var image: String
    var impactDescription: String
    var name: String
    var targetDonations: Float
    var totalDonations: Float
    var storeIDs: Set<Int> = .init()
    
    init(cause: String,
         id: Int,
         description: String,
         image: String,
         impactDescription: String,
         name: String,
         targetDonations: Float,
         totalDonations: Float) {
        self.cause = cause
        self.id = id
        self.missionDescription = description
        self.image = image
        self.impactDescription = impactDescription
        self.name = name
        self.targetDonations = targetDonations
        self.totalDonations = totalDonations
        super.init()
    }
}

// TODO lookup internal v private
// RENAME TO BKSTORE?
internal class Store: NSObject {
    var logo: String?
    var rectLogo: String?
    var name: String?
    var percent: Float?
    let id: Int
    
    init(id: Int,
         image: String? = nil,
         rect: String? = nil,
         name: String? = nil) {
        self.id = id
        self.logo = image
        self.rectLogo = rect
        super.init()
    }
}

class StoreNonprofitsModel: NSObject {
    var nonprofits: [Nonprofit]?
    var lastNonprofit: Nonprofit?
    var store: Store?
}

class Transaction: NSObject {
    let storeNon: StoreNonprofitsModel
    let amount: Float
    var chosenNonprofit: Int? = nil
    
    init(storeNon: StoreNonprofitsModel, amount: Float) {
        self.storeNon = storeNon
        self.amount = amount
        super.init()
    }
}
