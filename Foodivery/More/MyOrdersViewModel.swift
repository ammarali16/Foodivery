//
//  MyOrdersViewModel.swift
//  Foodivery
//
//  Created by Admin on 4/22/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol MyOrdersViewModel {
    
    var httpResponseHandler: HTTPResponseDelegate? {get set}
    
    func getMyOrdersData()
    
}

class MyOrdersViewModelImp:  NSObject, MyOrdersViewModel {
  
    var httpResponseHandler: HTTPResponseDelegate?
    
    func getMyOrdersData() {
        
        let url = ApiRouter.getOrdersData
        
        HTTPClient.shared.get(url: url, completion: { success, responseData, error in
            
            if success {
                
                let json = JSON(responseData!)
              
                if json["success"].exists() {
                    
                    let decoder = JSONDecoder.init()
                    
                    do {
                        
                        let dataObject = try json["success"]["activeOrders"].rawData()
                        let orders = try decoder.decode([Orders].self, from: dataObject)
                        
//                        let dataObject = try json["success"]["activeOrders"][0]["order_items"][0].rawData()
//                        let orders = try decoder.decode(OrderItems.self, from: dataObject)
                        
                    
                        CoreDataManager.shared.deleteAllOrders()
                        CoreDataManager.shared.deleteAllOrdersItems()

                        for order in orders {

                            CoreDataManager.shared.addOrders(order: order)

                            for orderItems in order.order_items {

                                CoreDataManager.shared.addOrderItems(orderItems: orderItems)
                             
                            }

                        }
                      
                        
                        let pastOrderDataObject = try json["success"]["pastOrders"].rawData()
                        let pastOrders = try decoder.decode([Orders].self, from: pastOrderDataObject)
                        
                        //                        let dataObject = try json["success"]["activeOrders"][0]["order_items"][0].rawData()
                        //                        let orders = try decoder.decode(OrderItems.self, from: dataObject)
                        
                        
                       
                      
                        
                        for pastOrder in pastOrders {
                            
                            CoreDataManager.shared.addOrders(order: pastOrder)
                            
                            for orderItems in pastOrder.order_items {
                                
                                CoreDataManager.shared.addOrderItems(orderItems: orderItems)
                                
                            }
                            
                        }
                        
                 
                  
                        self.httpResponseHandler?.httpRequestFinishWithSuccess(response: "", service: .getMyOrders)
                        
                    } catch(let error) {
                        self.httpResponseHandler?.httpRequestFinishWithError(message: error.localizedDescription, service: .getMyOrders)
                    }
                    
                }else{
                    let errorMessage = json["error"].stringValue
                    self.httpResponseHandler?.httpRequestFinishWithError(message: errorMessage, service: .getMyOrders)
                }
                
            }else{
                self.httpResponseHandler?.httpRequestFinishWithError(message: (error?.localizedDescription)!, service: .getMyOrders)
            }
        })
    }
    
}
    
