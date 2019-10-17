//
//  ChangePasswordViewModel.swift
//  Foodivery
//
//  Created by Admin on 3/23/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

protocol ProfileViewModel {
    
     var httpResponseHandler: HTTPResponseDelegate? {get set}
    
    func changePassword(email: String, current_password: String, password: String, confirm_password: String)
    func updateProfileImage(imageData: Data)
    func editUser(name: String?, isPhoneVerified: Int?, contact: String?)
    //func deletedProfilePic(imageId: Int)
    
}

class ProfileViewModelImp: ProfileViewModel {

    
    
    var httpResponseHandler: HTTPResponseDelegate?
    
    func editUser(name: String?, isPhoneVerified: Int?, contact: String?) {
        
        let url = ApiRouter.editUser
        
        var params = Parameters()
        
        if let name = name {
            params["name"] = name
        }
        
        if let isPhoneVerified = isPhoneVerified {
            params["isPhoneVerified"] = isPhoneVerified
        }
        
        if let contact = contact {
            params["contact"] = contact
        }
        
        HTTPClient.shared.post(url: url, parameter: params, completion: {success, responseData, error in
            
            if success {
                let jsonString = String.init(data: responseData!, encoding: .utf8)
                print("jsonString: \(String(describing: jsonString))")
                
                let json = JSON(responseData!)
                print("json: \(json)")
                
                if json["success"].exists() {
                    let (userData, message) = self.saveUserData(json: json)
                    if let userData = userData {
                        self.httpResponseHandler?.httpRequestFinishWithSuccess(response: "", service: .editUser)
                    }else{
                        self.httpResponseHandler?.httpRequestFinishWithError(message: message, service: .editUser)
                    }
                }else{
                    let errorMessage = json["error"]["message"].stringValue
                    self.httpResponseHandler?.httpRequestFinishWithError(message: errorMessage, service: .editUser)
                }
            }else{
                self.httpResponseHandler?.httpRequestFinishWithError(message: (error?.localizedDescription)!, service: .editUser)
            }
        })
        
    }
    
    func changePassword(email: String, current_password: String, password: String, confirm_password: String) {
       
            
        let url = ApiRouter.changePassword
            
            let params: Parameters = [
                
                "email": email,
                "current_password": current_password,
                "password": password,
                "confirm_password": confirm_password
                
                ]
            
            HTTPClient.shared.post(url: url, parameter: params, completion: {success, responseData, error in
                
                if success {
                    
                    let json = JSON(responseData!)
                    print(json)
                    
                    if json["success"].exists() {
                        let message = json["success"]["message"].stringValue
                        self.httpResponseHandler?.httpRequestFinishWithSuccess(response: message, service: .changePassword)
                    }else{
                        let errorMessage = json["error"]["message"].stringValue
                        self.httpResponseHandler?.httpRequestFinishWithError(message: errorMessage, service: .changePassword)
                    }
                }else{
                    self.httpResponseHandler?.httpRequestFinishWithError(message: (error?.localizedDescription)!, service: .changePassword)
                }
            })
    }


    
    func updateProfileImage(imageData: Data){
        
        let url = ApiRouter.setProfilePic
        
        Alamofire.upload( multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "file", fileName: "file.jpg", mimeType: "image/jpg")
        },
                          to: url,
                          headers: HTTPClient.shared.getHTTPHeader(),
                          encodingCompletion: { encodingResult in
                            
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    let json = JSON(response.data!)
                                    
                                    print(json)
                                    
                                    if json["success"].exists() {
                                        
                                        let decoder = JSONDecoder.init()
                                        do {
                                            let dataObject = try json["success"].rawData()
                                            let userDataObject = try decoder.decode(UserData.self, from: dataObject)
                                          
                                            AppDefaults.userData = userDataObject
                                            
                                            self.httpResponseHandler?.httpRequestFinishWithSuccess(response: "", service: .setProfilePic)
                                        } catch(let error) {
                                            self.httpResponseHandler?.httpRequestFinishWithError(message: error.localizedDescription, service: .setProfilePic)
                                        }
                                        
                                    }else{
                                        let errorMessage = json["error"].stringValue
                                        self.httpResponseHandler?.httpRequestFinishWithError(message: errorMessage, service: .setProfilePic)
                                    }
                                }
                            case .failure(let encodingError):
                                print("error in uploading")
                                print(encodingError)
                            }
        }
        )
        
    }
    
    
    
    
    private func saveUserData(json: JSON) -> (UserData?, String) {
        
        let decoder = JSONDecoder.init()
        
        do {
            
            let dataObject = try json["success"].rawData()
            let userData = try decoder.decode(UserData.self, from: dataObject)
            print("user data: \(userData)")
            AppDefaults.userData = userData
           
            print("user data: \(AppDefaults.userData)")
            
            return (userData, "")
            
        } catch(let error) {
            return (nil, error.localizedDescription)
        }
    }
    
    
    
    
//    func deletedProfilePic(imageId: Int) {
//
//        let url = ApiRouter.deletedProfilePic + "\(imageId)"
//
//        HTTPClient.shared.delete(url: url, parameters: nil, completion: {success, responseData, error in
//
//            if success {
//
//                let json = JSON(responseData!)
//
//                if json["success"].exists() {
//                    if var userData = AppDefaults.userData {
//                        userData.profile_image = nil
//                        AppDefaults.userData = userData
//                    }
//                    let message = "Profile image deleted successfully."
//                    self.httpResponseHandler?.httpRequestFinishWithSuccess(response: message, service: .deletedProfilePic)
//                }else{
//                    let errorMessage = json["error"].stringValue
//                    self.httpResponseHandler?.httpRequestFinishWithError(message: errorMessage, service: .deletedProfilePic)
//                }
//            }else{
//                self.httpResponseHandler?.httpRequestFinishWithError(message: (error?.localizedDescription)!, service: .deletedProfilePic)
//            }
//        })
//
//    }

    
    
    
    
}

