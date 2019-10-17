//
//  PaymentViewModel.swift
//  Foodivery
//
//  Created by Admin on 4/8/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

protocol PaymentViewModel {
    
    var httpResponseHandler: HTTPResponseDelegate? {get set}
    
    func createOrder(delivery_time: String, user_address_id: Int, payment_method: Int, cartArray: [Cart])
    
}

class PaymentViewModelImp: NSObject, PaymentViewModel {
    
    var httpResponseHandler: HTTPResponseDelegate?
    
    func createOrder(delivery_time: String, user_address_id: Int, payment_method: Int, cartArray: [Cart]) {
        
        let url = ApiRouter.createOrder
        
        var params: Parameters = [
            "delivery_time": delivery_time,
            "user_address_id": user_address_id,
            "payment_method": payment_method
        ]
        
        var itemsArray = [Parameters]()
        var dealsArray = [Parameters]()
        
        for cart in cartArray {
            
            if cart.isProduct {
                
                guard let product = cart.product else {return}
                
                let itemObj = [
                    "id": product.id,
                    "quantity": cart.quantity
                ]
                
                itemsArray.append(itemObj)
                
            }else{
                
                guard let deal = cart.deal else {return}
                
                let dealObj = [
                    "id": deal.id,
                    "quantity": cart.quantity
                ]
                
                dealsArray.append(dealObj)
            }
        }
        
        if itemsArray.count > 0 {
            params["items"] = itemsArray
        }
        
        if dealsArray.count > 0 {
            params["deals"] = dealsArray
        }
        
        var request = URLRequest(url: URL.init(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = HTTPClient.shared.getHTTPHeader()
        request.httpBody = try! JSONSerialization.data(withJSONObject: params)
        
        Alamofire.request(request)
            .responseJSON { response in
                
                switch response.result {
                    
                case .success(_):
                    
                    let json = JSON(response.data!)
                    print(json)
        
                    if json["success"]["status_message"].exists() {
                        let message = "Your order has been recieved. Waiting for Restaurant Manager to respond you."
                        self.httpResponseHandler?.httpRequestFinishWithSuccess(response: message, service: .createOrder)
                    }else{
                        let errorMessage = json["error"].stringValue
                        self.httpResponseHandler?.httpRequestFinishWithError(message: errorMessage, service: .createOrder)
                    }
                case .failure(let error):
                    self.httpResponseHandler?.httpRequestFinishWithError(message: error.localizedDescription, service: .createOrder)
                }
        }
        
    }
    
    
    
}


