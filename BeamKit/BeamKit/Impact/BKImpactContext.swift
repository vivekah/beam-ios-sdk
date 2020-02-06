//
//  BKImpactContext.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 11/14/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import Foundation

class BKImpactContext {
    
    lazy var api: ImpactAPI = .init()
    
    var impact: BKImpact? = nil
    var communityImpact: BKImpact? = nil

    var numberOfNonprofits: Int {
        return self.impact?.nonprofits.count ?? 0
    }
    
    var nonprofits: [Nonprofit]? {
        return self.impact?.nonprofits
    }
    
    // TODO surface errors in UI slash to devs
    
    func loadImpact() {
        api.getImpact { impact, error in
            guard !(error != nil) || error == BeamError.none,
                let impact = impact else {
                    return
            }
            self.impact = impact
        }
    }
    
    func loadCommunityImpact() {
        api.getCommunityImpact() { impact, error in
            guard !(error != nil) || error == BeamError.none,
                let impact = impact else {
                    return
            }
            self.communityImpact = impact
        }
    }
    
    func getImpact(for nonprofit: Nonprofit, _ completion: ((Nonprofit?, BeamError) -> Void)? = nil) {
        api.getImpact(for: nonprofit, completion)
    }
}
