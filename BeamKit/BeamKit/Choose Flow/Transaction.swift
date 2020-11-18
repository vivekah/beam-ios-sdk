//
//  Transaction.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 9/25/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let _bkdidSelectNonprofit = Notification.Name("bk_did_select_nonprofit")
    static let _bkdidCompleteTransaction = Notification.Name("bk_did_complete_transaction")
}

internal class BKNonprofit: NSObject {
    var cause: String?
    let id: Int
    let missionDescription: String?
    var image: String
    var impactDescription: String
    var name: String
    var targetDonations: CGFloat
    var totalDonations: CGFloat
    var storeIDs: Set<String> = .init()
    
    init(cause: String,
         id: Int,
         description: String,
         image: String,
         impactDescription: String,
         name: String,
         targetDonations: CGFloat,
         totalDonations: CGFloat) {
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
internal class BKStore: NSObject {
    var logo: String?
    var rectLogo: String?
    var name: String?
    var percent: CGFloat?
    var amount: CGFloat?
    var donationName: String?
    let id: String
    
    var matchTitle: String?
    var matchDescription: String?
    var matchPercent: CGFloat?
    
    init(id: String,
         image: String? = nil,
         rect: String? = nil,
         name: String? = nil) {
        self.id = id
        self.logo = image
        self.rectLogo = rect
        self.name = name
        super.init()
    }
}

class BKStoreNonprofitsModel: NSObject {
    var nonprofits: [BKNonprofit]?
    var lastNonprofit: BKNonprofit?
    var store: BKStore?
}

class BKTransaction: NSObject {
    let storeNon: BKStoreNonprofitsModel
    let amount: CGFloat
    var chosenNonprofit: BKNonprofit? = nil {
        didSet {
            NotificationCenter.default.post(name: ._bkdidSelectNonprofit,
                                            object: self,
                                            userInfo: ["transaction": self])
        }
    }
    var id: Int?
    var canMatch: Bool = false
    var userDidMatch: Bool = false
    var matchAmount: Double = 0
    var isRedeemed: Bool = false {
        didSet {
            guard isRedeemed == true else { return }
            NotificationCenter.default.post(name: ._bkdidCompleteTransaction,
                                             object: self,
                                             userInfo: ["transaction": self])
        }
    }
    
    init(storeNon: BKStoreNonprofitsModel, amount: CGFloat) {
        self.storeNon = storeNon
        self.amount = amount
        super.init()
        if let mtch = storeNon.store?.matchPercent {
            var amtInt: Double = Double(mtch * amount)
            amtInt = amtInt.cutOffDecimalsAfter(2)
            matchAmount = amtInt
        }
    }
}

