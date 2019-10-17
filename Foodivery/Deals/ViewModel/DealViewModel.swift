//
//  DealViewModel.swift
//  Foodivery
//
//  Created by Admin on 3/6/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol DealsViewModel {
    
    var httpResponseHandler: HTTPResponseDelegate? {get set}


    func getDealsData()

}

class DealsViewModelImp:  NSObject, DealsViewModel {
    
    var httpResponseHandler: HTTPResponseDelegate?

    func getDealsData() {
        
        let url = ApiRouter.getRestaurantData
        
        HTTPClient.shared.get(url: url, completion: { success, responseData, error in
            
            if success {
                
                let json = JSON(responseData!)
                
                if json["success"].exists() {
                    
                    let decoder = JSONDecoder.init()
                    
                    do {
                        
                        let dataObject = try json["success"]["deals"].rawData()
                        let deals = try decoder.decode([Deals].self, from: dataObject)
                        
                        CoreDataManager.shared.deleteAllDeals()
                        
                        
                        
                        for deal in deals {
                            
                            CoreDataManager.shared.addDeals(deal: deal)
            
                        }
                        
                        self.httpResponseHandler?.httpRequestFinishWithSuccess(response: "", service: .getRestaurantData)
                        
                    } catch(let error) {
                        self.httpResponseHandler?.httpRequestFinishWithError(message: error.localizedDescription, service: .getRestaurantData)
                    }
                    
                }else{
                    let errorMessage = json["error"].stringValue
                    self.httpResponseHandler?.httpRequestFinishWithError(message: errorMessage, service: .getRestaurantData)
                }
                
            }else{
                self.httpResponseHandler?.httpRequestFinishWithError(message: (error?.localizedDescription)!, service: .getRestaurantData)
            }
        })
    }
        
}
