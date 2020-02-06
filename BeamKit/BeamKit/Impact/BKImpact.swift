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
    let nonprofits: [Nonprofit]
    
    init(chainName: String,
         nonprofits: [Nonprofit]) {
        self.chainName = chainName
        self.nonprofits = nonprofits
    }
}

