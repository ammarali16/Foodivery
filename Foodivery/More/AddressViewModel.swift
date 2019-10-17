//
//  AddressViewModel.swift
//  Foodivery
//
//  Created by Admin on 3/19/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

protocol AddressViewModel {
    
    var httpResponseHandler: HTTPResponseDelegate? {get set}
    
    func getAllAddresses()
    func userAddress(title: String, address: String, street: String, area: String, floor: String)
    func editAddress(id: Int, title: String, address: String, street: String, area: String, floor: String)
    func deleteAddress(addressId: Int)
    
}

class AddressViewModelImp:  NSObject, AddressViewModel {
    
    var httpResponseHandler: HTTPResponseDelegate?
    

    func getAllAddresses() {
        
        let url = ApiRouter.getAllAddresses
        
        HTTPClient.shared.get(url: url, completion: { success, responseData, error in
            
            if success {
                
                let json = JSON(responseData!)
                
                if json["success"].exists() {
                    
                    let decoder = JSONDecoder.init()
                    
                    do {
                        
                        let dataObject = try json["success"].rawData()
                        let addresses = try decoder.decode([Address].self, from: dataObject)
                        
                       CoreDataManager.shared.deleteAllAddress()
                        
                        for address in addresses {
                            
                            CoreDataManager.shared.addAddress(address: address)
                          
                        }
 
                        self.httpResponseHandler?.httpRequestFinishWithSuccess(response: "", service: .getAllAddress)
                        
                    } catch(let error) {
                        self.httpResponseHandler?.httpRequestFinishWithError(message: error.localizedDescription, service: .getAllAddress)
                    }
                    
                }else{
                    let errorMessage = json["error"].stringValue
                    self.httpResponseHandler?.httpRequestFinishWithError(message: errorMessage, service: .getAllAddress)
                }
                
            }else{
                self.httpResponseHandler?.httpRequestFinishWithError(message: (error?.localizedDescription)!, service: .getAllAddress)
            }
        })
    }
    
    func editAddress(id: Int, title: String, address: String, street: String, area: String, floor: String) {
        
        let url = ApiRouter.editAddress + "\(id)"
        
        
        let params: Parameters = [
            "title" : title,
            "address" : address,
            "street" : street,
            "area" : area,
            "floor" : floor
        ]
        
        
        HTTPClient.shared.put(url: url, parameters: params, completion: {success, responseData, error in
            
            if success {
                
                let json = JSON(responseData!)
                print(json)
                
                
                if json["success"].exists() {
                    
                    print(json)
                    let decoder = JSONDecoder.init()
                    
                    do {
                        
                        let dataObject = try json["success"].rawData()
                        let address = try decoder.decode(Address.self, from: dataObject)
                        
                        CoreDataManager.shared.updateAddress(address: address)
                        
                        self.httpResponseHandler?.httpRequestFinishWithSuccess(response: "", service: .editAddress)
                        
                    } catch(let error) {
                        self.httpResponseHandler?.httpRequestFinishWithError(message: error.localizedDescription, service: .editAddress)
                    }
                    
                }else{
                    let errorMessage = json["error"].stringValue
                    self.httpResponseHandler?.httpRequestFinishWithError(message: errorMessage, service: .editAddress)
                }
                
            }else{
                self.httpResponseHandler?.httpRequestFinishWithError(message: (error?.localizedDescription)!, service: .editAddress)
            }
        })
    }
    
    func deleteAddress(addressId: Int) {
        
        print("id : \(addressId)")
        
        let url = ApiRouter.deleteAddress + "\(addressId)"
       
        HTTPClient.shared.delete(url: url, completion: {success, responseData, error in
            
            if success {
                
                let json = JSON(responseData!)
                print(json)
                
                
                if json["success"].exists() {
                    
                    print(json)
                    let decoder = JSONDecoder.init()
                    
                    do {
                        
                        let message = try json["success"].stringValue
                       
                        
                        CoreDataManager.shared.deleteAddressById(addressId: addressId)
                      
                        
                        self.httpResponseHandler?.httpRequestFinishWithSuccess(response: message, service: .deleteAddress)
                        
                    } catch(let error) {
                        self.httpResponseHandler?.httpRequestFinishWithError(message: error.localizedDescription, service: .deleteAddress)
                    }
                    
                }else{
                    let errorMessage = json["error"].stringValue
                    self.httpResponseHandler?.httpRequestFinishWithError(message: errorMessage, service: .deleteAddress)
                }
                
            }else{
                self.httpResponseHandler?.httpRequestFinishWithError(message: (error?.localizedDescription)!, service: .deleteAddress)
            }
        })
    }
    
    func userAddress(title: String, address: String, street: String, area: String, floor: String) {
     
         let url = ApiRouter.address
        let params: Parameters = [
                    "title" : title,
                    "address" : address,
                    "street" : street,
                    "area" : area,
                    "floor" : floor
                    ]
        
        
        HTTPClient.shared.post(url: url, parameter: params, completion: {success, responseData, error in
            
            if success {
                
                let json = JSON(responseData!)
                
                if json["success"].exists() {
                    
                    print(json)
                    let decoder = JSONDecoder.init()
                    
                    do {
                        
                        let dataObject = try json["success"].rawData()
                        let address = try decoder.decode(Address.self, from: dataObject)
                        
                        CoreDataManager.shared.addAddress(address: address)
                       
                        self.httpResponseHandler?.httpRequestFinishWithSuccess(response: "", service: .address)
                        
                    } catch(let error) {
                        self.httpResponseHandler?.httpRequestFinishWithError(message: error.localizedDescription, service: .address)
                    }
                    
                }else{
                    let errorMessage = json["error"].stringValue
                    self.httpResponseHandler?.httpRequestFinishWithError(message: errorMessage, service: .address)
                }
                
            }else{
                self.httpResponseHandler?.httpRequestFinishWithError(message: (error?.localizedDescription)!, service: .address)
            }
        })
    }
    

}
