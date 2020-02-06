//
//  NonprofitAPI.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 9/27/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import Foundation

class NonprofitAPI {
    class func getNonprofits(at storeID: Int,
                             _ completion: ((StoreNonprofitsModel?, BeamError) -> Void)? = nil) {
                
        let successHandler: (JSON?) -> Void = {  nonprofitJSON in
            BKLog.info("Did Retrieve Nonprofits for store \(storeID)")
            guard let json = nonprofitJSON,
                let model = parseStoreNonprofitJSON(json, for: storeID) else {
                    completion?(nil, .invalidConfiguration)
                    return
            }
            completion?(model, .none)
        }
        
        let errorHandler: (ErrorType) -> Void = { error in
            BKLog.error("Nonprofit Error")
            completion?(nil, .networkError)
        }
        
        // TODO Change this to context
        guard let userID = BeamKitContext.shared.userID else {
            completion?(nil, .invalidUser)
            return
        }
        
        Network.shared.get(urlPath: "nonprofits?store=\(storeID)&user=\(userID)",
                           successJSONHandler: successHandler,
                           errorHandler: errorHandler)
    }
    
    class func parseStoreNonprofitJSON(_ json: JSON, for storeID: Int) -> StoreNonprofitsModel? {
        let model = StoreNonprofitsModel()
        if let lastNon = json["last_nonprofit"] as? JSON {
            model.lastNonprofit = NonprofitAPI.parseNonprofitJSON(lastNon)
        }
        if let nonprofits = json["nonprofits"] as? [JSON] {
            var parsed = [Nonprofit]()
            for non in nonprofits {
                let parsed_nonprofit = NonprofitAPI.parseNonprofitJSON(non)
                parsed_nonprofit.storeIDs.insert(storeID)
                parsed.append(parsed_nonprofit)
            }
            if !parsed.isEmpty {
                model.nonprofits = parsed
            }
        }

        if let storeJSON = json["store"] as? JSON {
            let storeImage = storeJSON["logo"] as? String
            let name = storeJSON["chain_name"] as? String
            let rectLogo = storeJSON["rect_logo"] as? String
            let store = Store(id: storeID,
                              image: storeImage,
                              rect: rectLogo,
                              name: name)
            store.percent = 0.01
            if let percent = storeJSON["donation_percentage"] as? Float {
                store.percent = percent
            }
            model.store = store
        }
        return model
    }
    

    // COULD DO: Raise exception for poorly formed nonprofit??? / return null?
    class func parseNonprofitJSON(_ json: JSON) -> Nonprofit {
        let name = json["name"] as? String ?? ""
        let id = json["id"] as? Int ?? 0
        let cause = json["cause"] as? String ?? ""
        let impact_description = json["impact_description"] as? String ?? ""
        let descripton = json["descripton"] as? String
        let image = json["image"] as? String ?? ""
        
        let impact = json["impact"] as? JSON
        let total_donated = impact?["total_donated"] as? Float ?? 0
        let goal_amount = impact?["target_donation_amount"] as? Float ?? 10
        
        
        let nonprofit = Nonprofit(cause: cause,
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
                               store: Int,
                               cart: Float,
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
}
