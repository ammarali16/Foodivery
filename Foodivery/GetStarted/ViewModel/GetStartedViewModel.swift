//
//  GetStartedViewModel.swift
//  Foodivery
//
//  Created by Admin on 3/14/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import FBSDKLoginKit
import FBSDKCoreKit

protocol GetStartedViewModel {
    
    var httpResponseHandler: HTTPResponseDelegate? {get set}
    
    func registerUser(name: String, email: String, password: String, c_password: String)
    func loginUser(email: String, password: String)
    func forgotPassword(email: String)
    func registerDeviceFcm(fcm_token: String, platform: String)
    func loginWithFacebook(vc: UIViewController)
    func socialSignIn(id: String, name: String, email: String, image: String)
    func logoutUser()
}

class GetStartedViewModelImp: NSObject, GetStartedViewModel {
   
    
    var httpResponseHandler: HTTPResponseDelegate?
   
    
//    func loginUser(email: String, password: String) {
//
//        let url = ApiRouter.loginUser
//
//        let params: Parameters = [
//
//            "email": email,
//            "password": password
//
//            ]
//
//        HTTPClient.shared.post(url: url, parameter: params, completion: {success, responseData, error in
//
//            if success {
//
//                let json = JSON(responseData!)
//
//                print("json: \(json)")
//
//                if json["success"].exists() {
//
//
//                    let message = json["success"]["user"].stringValue
//                    self.httpResponseHandler?.httpRequestFinishWithSuccess(response: message, service: .login)
//                }else{
//                    let errorMessage = json["error"]["message"].stringValue
//                    self.httpResponseHandler?.httpRequestFinishWithError(message: errorMessage, service: .login)
//                }
//            }else{
//                self.httpResponseHandler?.httpRequestFinishWithError(message: (error?.localizedDescription)!, service: .login)
//            }
//        })
//    }
    
    
    func registerUser(name: String, email: String, password: String, c_password: String) {
        
        let url = ApiRouter.registerUser
        
        let params: Parameters = [
            "name": name,
            "email": email,
            "password": password,
            "c_password": c_password,
            
        ]
        
        HTTPClient.shared.post(url: url, parameter: params, completion: {success, responseData, error in
            
            if success {
                
                let json = JSON(responseData!)
                
                print("json: \(json)")
                
                if json["success"].exists() {
                    
                    print("json: \(json)")
                    let message = json["success"]["message"].stringValue
                    self.httpResponseHandler?.httpRequestFinishWithSuccess(response: message, service: .registerUser)
                }else{
                    let errorMessage = json["error"]["message"].stringValue
                    self.httpResponseHandler?.httpRequestFinishWithError(message: errorMessage, service: .registerUser)
                }
            }else{
                self.httpResponseHandler?.httpRequestFinishWithError(message: (error?.localizedDescription)!, service: .registerUser)
            }
        })
    }
    
    
    func loginUser(email: String, password: String){

        let url = ApiRouter.loginUser

        let params: Parameters = [
            "email": email,
            "password": password
        ]

        HTTPClient.shared.post(url: url, parameter: params, completion: {success, responseData, error in

            if success {
                let jsonString = String.init(data: responseData!, encoding: .utf8)
                print("jsonString: \(String(describing: jsonString))")

                let json = JSON(responseData!)
                print("json: \(json)")

                if json["success"].exists() {
                    let (userData, message) = self.saveUserData(json: json)
                    if let userData = userData {
                        self.httpResponseHandler?.httpRequestFinishWithSuccess(response: "", service: .login)
                    }else{
                        self.httpResponseHandler?.httpRequestFinishWithError(message: message, service: .login)
                    }
                }else{
                    let errorMessage = json["error"]["message"].stringValue
                    self.httpResponseHandler?.httpRequestFinishWithError(message: errorMessage, service: .login)
                }
            }else{
                self.httpResponseHandler?.httpRequestFinishWithError(message: (error?.localizedDescription)!, service: .login)
            }
        })

    }
    
    
    func logoutUser(){
        
        let url = ApiRouter.logoutUser + "\(AppDefaults.fcmToken)"
        
       
        HTTPClient.shared.post(url: url, parameter: nil, completion: {success, responseData, error in
            

            if success {
                
                let json = JSON(responseData!)
                
                print("json: \(json)")
                
                if json["success"].exists() {
                    
                    print("json: \(json)")
                    let message = json["success"]["message"].stringValue
                    self.httpResponseHandler?.httpRequestFinishWithSuccess(response: message, service: .logOut)
                }else{
                    let errorMessage = json["error"].stringValue
                    self.httpResponseHandler?.httpRequestFinishWithError(message: errorMessage, service: .logOut)
                }
            }else{
                self.httpResponseHandler?.httpRequestFinishWithError(message: (error?.localizedDescription)!, service: .logOut)
            }
        })
        
    }
    
    
    func loginWithFacebook(vc: UIViewController) {
        
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["email", "public_profile"], from: vc, handler: { (result, error) in
            
            if let error = error {
                Alert.showAlert(vc: vc, title: "Facebook Login Error!", message: error.localizedDescription)
            } else if result!.isCancelled {
                print("Process Cancelled")
            } else {
                if (result?.grantedPermissions .contains("email"))! {
                    // Create request for user's Facebook data
                    FBSDKGraphRequest(graphPath:"me", parameters:["fields": "id, name, email"]).start(completionHandler: { (connection, result, error) in
                        if error != nil {
                            print("facebook error: \(String(describing: error?.localizedDescription))")
                        }
                        else if let userData = result as? [String:AnyObject] {
                            
                            if let fbId = userData["id"] as? String, let name = userData["name"] as? String, let email = userData["email"] as? String {
                                
                                let imageURL = String.init(format: "http://graph.facebook.com/%@/picture?type=large", fbId)
                                
                                print("fbId: \(String(describing: fbId))", "name: \(String(describing: name))", "email: \(String(describing: email))", "image: \(String(describing: imageURL))" )
                                
                                Loader.showLoader(viewController: vc)
                                self.socialSignIn(id: fbId, name: name, email: email, image: imageURL)
                                
                            }else{
                                Alert.showAlert(vc: vc, title: "Error!", message: "In fatched information, something missing. You can not login with this account.")
                            }
                        }
                    })
                }
            }
        })
        
    }
    
    
    
    
    func socialSignIn(id: String, name: String, email: String, image: String) {
        
        let url = ApiRouter.socialSingIn
        
        let params: Parameters = [
            
            "name": name,
            "email": email,
            "avatar": image,
            "uid": id
        ]
        
        HTTPClient.shared.post(url: url, parameter: params, completion: {success, responseData, error in
            
            if success {
                
                let json = JSON(responseData!)
                
                if json["success"].exists() {
                    let (userData, message) = self.saveUserData(json: json)
                    if let userData = userData {
                        self.httpResponseHandler?.httpRequestFinishWithSuccess(response: userData, service: .socialSingIn)
                    }else{
                        self.httpResponseHandler?.httpRequestFinishWithError(message: message, service: .socialSingIn)
                    }
                }else{
                    let errorMessage = json["error"].stringValue
                    self.httpResponseHandler?.httpRequestFinishWithError(message: errorMessage, service: .socialSingIn)
                }
            }else{
                self.httpResponseHandler?.httpRequestFinishWithError(message: (error?.localizedDescription)!, service: .socialSingIn)
            }
        })
        
    }
    
    private func saveUserData(json: JSON) -> (UserData?, String) {
        
        let decoder = JSONDecoder.init()
        
        do {
            
            let dataObject = try json["success"]["user"].rawData()
            let userData = try decoder.decode(UserData.self, from: dataObject)
            print("user data: \(userData)")
            AppDefaults.userData = userData
            
            print("appDefaults: \(AppDefaults.userData)")
            

            AppDefaults.apiToken = json["success"]["user"]["token"].stringValue
            print("api token: \(AppDefaults.apiToken)")
            
            AppDefaults.isLogin = true
             let login = AppDefaults.isLogin
            print("login\(login)")
            
            AppDefaults.isPhoneVerified = json["success"]["user"]["isPhoneVerified"].intValue
            
            
            return (userData, "")
            
        } catch(let error) {
            return (nil, error.localizedDescription)
        }
    }
    
    
    func forgotPassword(email: String){
        
        let url = ApiRouter.forgetPassword
        let params: Parameters = [
            "email": email
        ]
        
        HTTPClient.shared.post(url: url, parameter: params, completion: {success, responseData, error in
            if success {
                let json = JSON(responseData!)
                print("json: \(json)")
                
                if json["success"].exists() {
                    let message = json["success"]["message"].stringValue
                    self.httpResponseHandler?.httpRequestFinishWithSuccess(response: message, service: .forgetPassword)
                }else{
                    let errorMessage = json["error"]["message"][0].stringValue
                    self.httpResponseHandler?.httpRequestFinishWithError(message: errorMessage, service: .forgetPassword)
                }
            }else{
                self.httpResponseHandler?.httpRequestFinishWithError(message: (error?.localizedDescription)!, service: .forgetPassword)
            }
        })
        
    }
    
    
    func registerDeviceFcm(fcm_token: String, platform: String) {
        
        let url = ApiRouter.registerDeviceFcm
        
        let params: Parameters = [
            "fcm_token" : fcm_token,
            "platform" : platform
        ]
        
        HTTPClient.shared.post(url: url, parameter: params, completion: {success, responseData, error in
            
            if success {
                
                let json = JSON(responseData!)
                
                print("json: \(json)")
                if json["success"].exists() {
                    
                    let registerDeviceFcm = json["success"].stringValue
                    
                    
                    self.httpResponseHandler?.httpRequestFinishWithSuccess(response: registerDeviceFcm, service: .registerDeviceFcm)
                    
                }else{
                    if let errorMessage = json["error"]["user"][0].string {
                        self.httpResponseHandler?.httpRequestFinishWithError(message: errorMessage, service: .registerDeviceFcm)
                    }else{
                        let errorMessage = json["error"].stringValue
                        self.httpResponseHandler?.httpRequestFinishWithError(message: errorMessage, service: .registerDeviceFcm)
                    }
                }
            }else{
                self.httpResponseHandler?.httpRequestFinishWithError(message: (error?.localizedDescription)!, service: .registerDeviceFcm)
            }
        })
        
    }
    
    
//    func registerUser(name: String, email: String, password: String, c_password: String, isPhoneVerified: Bool, contact: String) {
//
//        let url = ApiRouter.registerUser
//
//        let params: Parameters = [
//            "name": name,
//            "email": email,
//            "password": password,
//            "c_password": c_password,
//            "isPhoneVerified": NSNumber.init(value: isPhoneVerified),
//            "contact": contact
//        ]
//
//        HTTPClient.shared.post(url: url, parameter: params, completion: {success, responseData, error in
//
//            if success {
//
//                let json = JSON(responseData!)
//
//                print("json: \(json)")
//
//                if json["success"].exists() {
//
//                    print("json: \(json)")
//                    let message = json["success"]["message"].stringValue
//                    self.httpResponseHandler?.httpRequestFinishWithSuccess(response: message, service: .registerUser)
//                }else{
//                    let errorMessage = json["error"]["message"].stringValue
//                    self.httpResponseHandler?.httpRequestFinishWithError(message: errorMessage, service: .registerUser)
//                }
//            }else{
//                self.httpResponseHandler?.httpRequestFinishWithError(message: (error?.localizedDescription)!, service: .registerUser)
//            }
//        })
//    }
    
    
    
}
