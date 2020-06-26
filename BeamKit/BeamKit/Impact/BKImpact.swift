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

