//
//  NonprofitAPI.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 9/27/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import UIKit

class NonprofitAPI {
    class func getNonprofits(at storeID: String,
                             _ completion: ((BKStoreNonprofitsModel?, Bool, BeamError) -> Void)? = nil) {
                
        let successHandler: (JSON?) -> Void = {  nonprofitJSON in
            BKLog.info("Did Retrieve Nonprofits for store \(storeID)")
            guard let json = nonprofitJSON,
                let model = parseStoreNonprofitJSON(json, for: storeID) else {
                    completion?(nil, false, .invalidConfiguration)
                    return
            }
            let match = json["user_can_match"] as? Bool ?? false
            completion?(model, match, .none)
        }
        
        let errorHandler: (ErrorType) -> Void = { error in
            BKLog.error("Nonprofit Error")
            completion?(nil, false, .networkError)
        }
        
        guard let userID = BeamKitContext.shared.userID else {
            completion?(nil, false, .invalidUser)
            return
        }
        
        Network.shared.get(urlPath: "nonprofits/?store=\(storeID)&user=\(userID)",
                           successJSONHandler: successHandler,
                           errorHandler: errorHandler)
    }
    
    class func parseStoreNonprofitJSON(_ json: JSON, for storeID: String) -> BKStoreNonprofitsModel? {
        let model = BKStoreNonprofitsModel()
        let lastNon = json["last_nonprofit"] as? Int ?? 0
    
        if let nonprofits = json["nonprofits"] as? [JSON] {
            var parsed = [BKNonprofit]()
            for non in nonprofits {
                let parsed_nonprofit = NonprofitAPI.parseNonprofitJSON(non)
                parsed_nonprofit.storeIDs.insert(storeID)
                parsed.append(parsed_nonprofit)
                if parsed_nonprofit.id == lastNon {
                    model.lastNonprofit = parsed_nonprofit
                }
            }
            if !parsed.isEmpty {
                model.nonprofits = parsed
            }
        }
  
        if let storeJSON = json["store"] as? JSON {
            let storeImage = storeJSON["logo"] as? String
            let name = storeJSON["chain_name"] as? String
            let rectLogo = storeJSON["rect_logo"] as? String
            let store = BKStore(id: storeID,
                                image: storeImage,
                                rect: rectLogo,
                                name: name)
            store.percent = 0.01
            if let percent = storeJSON["donation_percentage"] as? CGFloat {
                store.percent = percent
            }
            if let donationType = storeJSON["chain_donation_type"] as? JSON {
                let name = donationType["name"] as? String
                let amount = donationType["donation_amount"] as? CGFloat ?? 0
                let percent = donationType["donation_percentage"] as? CGFloat ?? 0
                store.percent = percent
                store.donationName = name
                store.amount = amount
            }
            
            if let matchDonationType = storeJSON["match_donation_type"] as? JSON {
                let title = matchDonationType["title"] as? String
                let value = matchDonationType["description"] as? String
                let percent = matchDonationType["donation_percentage"] as? CGFloat
                store.matchTitle = title
                store.matchDescription = value
                store.matchPercent = percent
            }
            model.store = store
        }

        return model
    }
    

    // COULD DO: Raise exception for poorly formed nonprofit??? / return null?
    class func parseNonprofitJSON(_ json: JSON) -> BKNonprofit {
        let name = json["name"] as? String ?? ""
        let id = json["id"] as? Int ?? 0
        let cause = json["cause"] as? String ?? ""
        let impact_description = json["impact_description"] as? String ?? ""
        let descripton = json["description"] as? String
        let image = json["image"] as? String ?? ""
        
        let impact = json["impact"] as? JSON
        let total_donated = impact?["total_donated"] as? CGFloat ?? 0
        let goal_amount = impact?["target_donation_amount"] as? CGFloat ?? 10
        
        
        let nonprofit = BKNonprofit(cause: cause,
                                    id: id,
                                    description: descripton ?? "",
                                    image: image,
                                    impactDescription: impact_description,
                                    name: name,
                                    targetDonations: goal_amount,
                                    totalDonations: total_donated)
        return nonprofit
    }
    
    class func selectNonprofit(id: Int,
                               store: String,
                               cart: CGFloat,
                               match: Bool,
                               position: Int,
                               _ completion: ((Int?, BeamError) -> Void)? = nil) {
        guard let user = BeamKitContext.shared.userID else {
            completion?(nil, .invalidUser)
            return
        }
        
        let body: JSON  = ["user": user,
                           "store": store,
                           "cart_total": cart,
                           "nonprofit": id,
                           "user_did_match": match,
                           "nonprofit_position": position]
        
        let successHandler: (JSON?) -> Void = {  transactionJSON in
            guard let transactionID = transactionJSON?["transaction"] as? Int else {
                BKLog.error("Select Nonprofit: invalid response")
                completion?(nil, .invalidConfiguration)
                return 
            }
            
            BKLog.debug("Beam Registered Transaction with id \(transactionID)")
            completion?(transactionID, .none)
        }
        
        let errorHandler: (ErrorType) -> Void = { error in
            BKLog.error("Select Nonprofit Error")
            completion?(nil, .networkError)
        }
        
        Network.shared.post(urlPath: "transaction/",
                            body: body,
                            successJSONHandler: successHandler,
                            errorHandler: errorHandler)
    }
    
    class func cancelTransaction(id: Int,
                               _ completion: ((BeamError) -> Void)? = nil) {
        guard let _ = BeamKitContext.shared.userID else {
            completion?(.invalidUser)
            return
        }

        let successHandler: (JSON?) -> Void = {  _ in

            BKLog.debug("Beam cancelled Transaction with id \(id)")
            completion?(.none)
        }
        
        let errorHandler: (ErrorType) -> Void = { error in
            BKLog.error("Cancel Transaction Error")
            completion?(.networkError)
        }
        
        Network.shared.patch(urlPath: "transaction/?transaction=\(id)",
                            successJSONHandler: successHandler,
                            errorHandler: errorHandler)
    }
}
