//
//  ImpactAPI.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 10/12/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import UIKit

class ImpactAPI {
    
    func getImpact(_ completion: ((BKImpact?, BeamError)-> Void)? = nil) {
        guard let userID = BeamKitContext.shared.getUserID() else {
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
         
            completion?(impact, .none)
        }
        
        let errorHandler: (ErrorType) -> Void = { error in
            BKLog.error("See Impact Error")
            completion?(nil, .networkError)
        }
        Network.shared.get(urlPath: "impact/?user=\(userID)",
        successJSONHandler: successHandler,
        errorHandler: errorHandler)
    }
    
    func getImpact(for nonprofit: BKNonprofit, _ completion: ((BKNonprofit?, BeamError) -> Void)? = nil) {
        guard let userID = BeamKitContext.shared.getUserID() else {
            BKLog.error("Invalid User Error")
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
    
    func getCommunityImpact(_ completion: ((BKImpact?, BeamError) -> Void)? = nil) {
        
        let successHandler: (JSON?) -> Void = {  impactJSON in
            guard let impactJSON = impactJSON else {
                BKLog.error("Get Impact: invalid response")
                completion?(nil, .invalidConfiguration)
                return
            }
            let impact = ImpactAPI.parseNon(impactJSON)
         
            completion?(impact, .none)
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
    private class func parse(_ json: JSON, into nonprofit: BKNonprofit) -> BKNonprofit? {
        guard let chain = json["chain"] as? JSON,
            let name = chain["name"] as? String,
            let cause = json["cause"] as? String,
            let image = json["image"] as? String,
            let desc = json["impact_description"] as? String,
            let impact = json["impact"] as? JSON,
            let total_donated = impact["total_donated"] as? CGFloat,
            let target_donation = impact["target_donation_amount"] as? CGFloat else { return nil }
        
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
        
        var nonprofits: [BKNonprofit] = .init()
        if let nonprofitJSON = json["nonprofits"] as? [JSON] {
            for non in nonprofitJSON  {
                let parsed_nonprofit = NonprofitAPI.parseNonprofitJSON(non)
                nonprofits.append(parsed_nonprofit)
            }
        }
        
        let logo = chain["rect_logo"] as? String ?? chain["logo"] as? String ?? nil
        
        return BKImpact(chainName: name, logo: logo, nonprofits: nonprofits)
    }
    
}


extension ImpactAPI {
    
    func getInstacartImpact(_ completion: ((BK_INSImpact?, BeamError) -> Void)? = nil) {
        
        let successHandler: (JSON?) -> Void = {  impactJSON in
              guard let impactJSON = impactJSON else {
                BKLog.error("Get Impact: invalid response")
                completion?(nil, .invalidConfiguration)
                return
            }
            BKLog.info("Did Retrieve Instacart Impact JSON \(impactJSON)")
            let impact = ImpactAPI.parseIns(impactJSON)
            completion?(impact, .none)
        }
        
        let errorHandler: (ErrorType) -> Void = { error in
            BKLog.error("See Impact Error")
            completion?(nil, .networkError)
        }
        
        guard let userID = BeamKitContext.shared.getUserID() else {
            completion?(nil, .invalidUser)
            return
        }
        Network.shared.get(urlPath: "users/impact/instacart?user=\(userID)",
        successJSONHandler: successHandler,
        errorHandler: errorHandler)
    }
    
    private class func parseIns(_ json: JSON) -> BK_INSImpact? {
        let copy = json["copy"] as? JSON ?? [:]
        let parsedCopy = parse(copy: copy)
        
        var nonprofits: [BKNonprofit] = .init()
        if let nonprofitJSON = json["community_impact"] as? [JSON] {
            for non in nonprofitJSON  {
                let parsed_nonprofit = NonprofitAPI.parseNonprofitJSON(non)
                nonprofits.append(parsed_nonprofit)
            }
        }
        

        return BK_INSImpact(copy: parsedCopy, nonprofits: nonprofits)
    }
    
    private class func parse(copy copyJSON: JSON) -> BK_INSCopy {
        let copy = BK_INSCopy()
        copy.subtitle = copyJSON["impactDescriptionMobile"] as? String
        copy.title = copyJSON["impactTitleMobile"] as? String
        copy.complianceCTA = copyJSON["complianceCtaMobile"] as? String
        copy.complianceDescription = copyJSON["complianceDescriptionMobile"] as? String
        
        return copy
    }
}
