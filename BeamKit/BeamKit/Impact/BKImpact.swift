//
//  BKImpact.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 10/12/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import UIKit

class BKImpact {
    let chainName: String
    let nonprofits: [BKNonprofit]
    let logo: String?
    
    init(chainName: String,
         logo: String?,
         nonprofits: [BKNonprofit]) {
        self.chainName = chainName
        self.logo = logo
        self.nonprofits = nonprofits
    }
}

class BK_INSCopy {
    var subtitle: String?
    var title: String?
    var complianceCTA: String?
    var complianceDescription: String?
}

class BK_INSImpact {
    let nonprofits: [BKNonprofit]
    let copy: BK_INSCopy
    
    init(copy: BK_INSCopy,
         nonprofits: [BKNonprofit]) {
        self.nonprofits = nonprofits
        self.copy = copy 
    }
}
