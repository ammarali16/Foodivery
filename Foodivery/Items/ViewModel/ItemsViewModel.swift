//
//  MenuViewModel.swift
//  Foodivery
//
//  Created by Admin on 2/28/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

protocol ItemsViewModel {
    
    var httpResponseHandler: HTTPResponseDelegate? {get set}

    func getAllItems(subcategoryId: Int)
   
    
}

class ItemsViewModelImp:  NSObject, ItemsViewModel {
    
    var httpResponseHandler: HTTPResponseDelegate?
    
    func getAllItems(subcategoryId: Int) {
        
        let url = ApiRouter.getAllProductBySubcategory + "\(subcategoryId)"
        
        HTTPClient.shared.get(url: url, completion: { success, responseData, error in
            
            if success {
                
                let json = JSON(responseData!)
                
                print(json)
                if json["success"].exists() {
                   
                    let decoder = JSONDecoder.init()
                    
                    do {
                        
                        let dataObject = try json["success"].rawData()
                        let products = try decoder.decode([Product].self, from: dataObject)
                        
                        CoreDataManager.shared.deleteAllProductsBySubcategory(subcategoryId: subcategoryId)
                        
                        for product in products {
                            CoreDataManager.shared.addProduct(product: product)
                        }
                        
                        self.httpResponseHandler?.httpRequestFinishWithSuccess(response: "", service: .getAllProductBySubcategory)
                        
                    } catch(let error) {
                        self.httpResponseHandler?.httpRequestFinishWithError(message: error.localizedDescription, service: .getAllProductBySubcategory)
                    }
                    
                }else{
                    let errorMessage = json["error"].stringValue
                    self.httpResponseHandler?.httpRequestFinishWithError(message: errorMessage, service: .getAllProductBySubcategory)
                }
                
            }else{
                self.httpResponseHandler?.httpRequestFinishWithError(message: (error?.localizedDescription)!, service: .getAllProductBySubcategory)
            }
        })
    }
}
