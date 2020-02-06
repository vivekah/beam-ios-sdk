//
//  ImpactAPI.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 10/12/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import Foundation

class ImpactAPI {
    
    func getImpact(_ completion: ((BKImpact?, BeamError?)-> Void)? = nil) {
        guard let userID = BeamKitContext.shared.userID else {
            completion?(nil, .invalidUser)
            return
        }
        
        let successHandler: (JSON?) -> Void = {  impactJSON in
            guard let impactJSON = impactJSON else {
                BKLog.error("Get Impact: invalid response")
                completion?(nil, .invalidConfiguration)
                return
            }
            let impact = ImpactAPI.parseNon(impactJSON)
         
            completion?(impact, BeamError.none)
        }
        
        let errorHandler: (ErrorType) -> Void = { error in
            BKLog.error("See Impact Error")
            completion?(nil, .networkError)
        }
        Network.shared.get(urlPath: "impact?user=\(userID)",
        successJSONHandler: successHandler,
        errorHandler: errorHandler)
    }
    
    func getImpact(for nonprofit: Nonprofit, _ completion: ((Nonprofit?, BeamError) -> Void)? = nil) {
        guard let userID = BeamKitContext.shared.userID else {
            completion?(nil, .invalidUser)
            return
        }
        
        let successHandler: (JSON?) -> Void = {  impactJSON in
            guard let impactJSON = impactJSON else {
                BKLog.error("Get Impact: invalid response")
                completion?(nil, .invalidConfiguration)
                return
            }
            let impact = ImpactAPI.parse(impactJSON, into: nonprofit)
            
            completion?(impact, .none)
        }
        
        let errorHandler: (ErrorType) -> Void = { error in
            BKLog.error("Select Nonprofit Error")
            completion?(nil, .networkError)
        }
        
        Network.shared.get(urlPath: "impact?nonprofit=\(nonprofit.id)&user=\(userID)",
                           successJSONHandler: successHandler,
                           errorHandler: errorHandler)
    }
    
    func getCommunityImpact(_ completion: ((BKImpact?, BeamError?) -> Void)? = nil) {
        
        let successHandler: (JSON?) -> Void = {  impactJSON in
            guard let impactJSON = impactJSON else {
                BKLog.error("Get Impact: invalid response")
                completion?(nil, .invalidConfiguration)
                return
            }
            let impact = ImpactAPI.parseNon(impactJSON)
         
            completion?(impact, BeamError.none)
        }
        
        let errorHandler: (ErrorType) -> Void = { error in
            BKLog.error("See Impact Error")
            completion?(nil, .networkError)
        }
        Network.shared.get(urlPath: "impact/",
        successJSONHandler: successHandler,
        errorHandler: errorHandler)
    }
    
    // TODO -- audit private denotations
    // NOTE: I really like the error messages here **pats own back**
    // TODO -- remove extraneous messagesss of self-support
    private class func parse(_ json: JSON, into nonprofit: Nonprofit) -> Nonprofit? {
        guard let chain = json["chain"] as? JSON,
            let name = chain["name"] as? String,
            let cause = json["cause"] as? String,
            let image = json["image"] as? String,
            let desc = json["impact_description"] as? String,
            let impact = json["impact"] as? JSON,
            let total_donated = impact["total_donated"] as? Float,
            let target_donation = impact["target_donation_amount"] as? Float else { return nil }
        
        if !name.isEmpty,
            name != nonprofit.name {
                BKLog.error("GET Impact error: nonprofit names do not match. Changing from \(nonprofit.name) to \(name)")
            nonprofit.name = name
        }
        
        if !cause.isEmpty,
            nonprofit.cause != cause {
            BKLog.error("GET IMPACT error: causes for nonprofit \(name) do not match. Changing from \(nonprofit.cause ?? "[no cause]") to \(cause)")
        }
        
        nonprofit.image = image
        nonprofit.impactDescription = desc
        nonprofit.targetDonations = target_donation
        nonprofit.totalDonations = total_donated
        return nonprofit
    }
    
    private class func parseNon(_ json: JSON) -> BKImpact? {
        guard let chain = json["chain"] as? JSON,
            let name = chain["name"] as? String  else { return nil }
        
        var nonprofits: [Nonprofit] = .init()
        if let nonprofitJSON = json["nonprofits"] as? [JSON] {
            for non in nonprofitJSON  {
                let parsed_nonprofit = NonprofitAPI.parseNonprofitJSON(non)
                nonprofits.append(parsed_nonprofit)
            }
        }
        
        return BKImpact(chainName: name, nonprofits: nonprofits)
    }
    
}
