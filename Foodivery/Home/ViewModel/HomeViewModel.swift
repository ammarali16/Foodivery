//
//  HomeViewModel.swift
//  Foodivery
//
//  Created by Admin on 2/1/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire


protocol HomeViewModel {
    
    var httpResponseHandler: HTTPResponseDelegate? {get set}
    
    func loginGuestUser()
    func getRestaurantData()
   
}

class HomeViewModelImp:  NSObject, HomeViewModel {
  
    var httpResponseHandler: HTTPResponseDelegate?
    
    func loginGuestUser() {
        
        let url = ApiRouter.loginGuestUser
        
        let params: Parameters = [
            "email" : AppConfig.email,
            "password" : AppConfig.password
        ]
        
        HTTPClient.shared.post(url: url, parameter: params, completion: {success, responseData, error in
            
            if success {
                
                let json = JSON(responseData!)
                
                print("json: \(json)")
                if json["success"].exists() {
                    
                    let token = json["success"]["user"]["token"].stringValue
                    AppDefaults.guestApiToken = token
                    
                    self.httpResponseHandler?.httpRequestFinishWithSuccess(response: "", service: .guestLogin)
                    //                    let (userData, message) = self.saveUserData(json: json)
                    //                    if let userData = userData {
                    //                        self.httpResponseHandler?.httpRequestFinishWithSuccess(response: userData, service: .registerUser)
                    //                    }else{
                    //                        self.httpResponseHandler?.httpRequestFinishWithError(message: message, service: .registerUser)
                    //                    }
                }else{
                    if let errorMessage = json["error"]["user"][0].string {
                        self.httpResponseHandler?.httpRequestFinishWithError(message: errorMessage, service: .guestLogin)
                    }else{
                        let errorMessage = json["error"].stringValue
                        self.httpResponseHandler?.httpRequestFinishWithError(message: errorMessage, service: .guestLogin)
                    }
                }
            }else{
                self.httpResponseHandler?.httpRequestFinishWithError(message: (error?.localizedDescription)!, service: .guestLogin)
            }
        })
    }
    
    
    func getRestaurantData() {
        
        let url = ApiRouter.getRestaurantData
        
        HTTPClient.shared.get(url: url, completion: { success, responseData, error in
            
            if success {
                
                let json = JSON(responseData!)
                
                if json["success"].exists() {
                    
                    let decoder = JSONDecoder.init()
                    
                    do {
                        
                        let dataObject = try json["success"]["categories"].rawData()
                        let categories = try decoder.decode([Category].self, from: dataObject)
                        
                        CoreDataManager.shared.deleteAllCateogries()
                        CoreDataManager.shared.deleteAllSubcateogries()
                        CoreDataManager.shared.deleteAllProducts()
                        
                        
                        for category in categories {
                            
                            CoreDataManager.shared.addCategory(category: category)
                            
                            for subCategory in category.sub_categories {
                                
                                CoreDataManager.shared.addSubcategory(subcategory: subCategory)
                                
                                for product in subCategory.five_items! {
                                    
                                    CoreDataManager.shared.addProduct(product: product)
                                }
                                
                            }
                            
                        }
                        
                        
                        
                        let slidersObject = try json["success"]["slides"].rawData()
                        let sliders = try decoder.decode([Sliders].self, from: slidersObject)
                        
                        CoreDataManager.shared.deleteAllSliders()
                        CoreDataManager.shared.deleteAllSlidersImage()



                        for slider in sliders {

                            CoreDataManager.shared.addSliders(sliders: slider)

                            for sliderImage in slider.media {

                                CoreDataManager.shared.addSlidersImage(slidersImage: sliderImage)

                            }

                        }



                        let dealsDataObject = try json["success"]["deals"].rawData()
                        let deals = try decoder.decode([Deals].self, from: dealsDataObject)

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

