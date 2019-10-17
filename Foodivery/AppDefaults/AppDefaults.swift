//
//  AppDefaults.swift
//  Foodivery
//
//  Created by Admin on 2/1/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import Foundation
import GoogleSignIn

class AppDefaults: NSObject {
    
    public static let defaults = UserDefaults.standard
    
   
    public static func clearUserDefaults(){
       
        let dictionary = AppDefaults.defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        
        AppDefaults.defaults.synchronize()
        
        GIDSignIn.sharedInstance().signOut()
    }
    
    public static var apiToken: String {
        get{
            if let token = AppDefaults.defaults.string(forKey: "apiToken") {
                return token
            }else{
                return ""
            }
        }
        set{
            AppDefaults.defaults.set(newValue, forKey: "apiToken")
            AppDefaults.defaults.synchronize()
        }
    }
    
    
    public static var guestApiToken: String {
        get{
            if let guestApiToken = AppDefaults.defaults.string(forKey: "guestApiToken") {
                return guestApiToken
            }else{
                return ""
            }
        }
        set{
            AppDefaults.defaults.set(newValue, forKey: "guestApiToken")
            AppDefaults.defaults.synchronize()
        }
    }
    
    public static var isLogin: Bool {
        get{
            return AppDefaults.defaults.bool(forKey: "isLogin")
        }
        set{
            AppDefaults.defaults.set(newValue, forKey: "isLogin")
            AppDefaults.defaults.synchronize()
        }
    }
    
    
    public static var isLoginFromSocial: Bool {
        
        get{
            return AppDefaults.defaults.bool(forKey: "isLoginFromSocial")
        }
        set{
            AppDefaults.defaults.bool(forKey: "isLoginFromSocial")
            AppDefaults.defaults.synchronize()
        }
    }
    
    //MARK :- User data
    public static var userData: UserData? {
        get{
            if let data = AppDefaults.defaults.data(forKey: "userData") {
                let decoder = JSONDecoder()
                do{
                    let decoded = try decoder.decode(UserData.self, from: data)
                    return decoded
                }catch{
                    return nil
                }
            }
            return nil
        }
        set{
            let encoder = JSONEncoder()
            do {
                let jsonData = try encoder.encode(newValue)
                AppDefaults.defaults.set(jsonData, forKey: "userData")
                AppDefaults.defaults.synchronize()
            }catch{
                print("userData not save")
            }
        }
    }
    
    
    public static var address: String {
        get{
            if let name = AppDefaults.defaults.string(forKey: "address") {
                return name
            }
            return ""
        }
        set{
            AppDefaults.defaults.set(newValue, forKey: "address")
            AppDefaults.defaults.synchronize()
        }
    }

    
    public static var contact: String {
        get{
            if let contact = AppDefaults.defaults.string(forKey: "contact") {
                return contact
            }
            return ""
        }
        set{
            AppDefaults.defaults.set(newValue, forKey: "contact")
            AppDefaults.defaults.synchronize()
        }
    }
    
    public static var defaultAddressId: Int {
        get{
            return AppDefaults.defaults.integer(forKey: "defaultAddressId")
        }
        set{
            AppDefaults.defaults.set(newValue, forKey: "defaultAddressId")
            AppDefaults.defaults.synchronize()
        }
    }
    
    public static var isPhoneVerified: Int {
        get{
            return AppDefaults.defaults.integer(forKey: "isPhoneVerified")
        }
        set{
            AppDefaults.defaults.set(newValue, forKey: "isPhoneVerified")
            AppDefaults.defaults.synchronize()
        }
    }
    
    public static var verificationId: String {
        get{
            if let verificationId = AppDefaults.defaults.string(forKey: "verificationId") {
                return verificationId
            }else{
                return ""
            }
        }
        set{
            AppDefaults.defaults.set(newValue, forKey: "verificationId")
            AppDefaults.defaults.synchronize()
        }
    }

    
    public static var fcmToken: String {
        get{
            if let fcmToken = AppDefaults.defaults.string(forKey: "fcmToken") {
                return fcmToken
            }else{
                return ""
            }
        }
        set{
            AppDefaults.defaults.set(newValue, forKey: "fcmToken")
            AppDefaults.defaults.synchronize()
        }
    }
    
    
    
    //MARK: - Location
    public static var location: Location? {
        get{
            if let data = AppDefaults.defaults.data(forKey: "location") {
                let decoder = JSONDecoder()
                do{
                    let decoded = try decoder.decode(Location.self, from: data)
                    return decoded
                }catch{
                    return nil
                }
            }
            return nil
        }
        set{
            let encoder = JSONEncoder()
            do {
                let jsonData = try encoder.encode(newValue)
                AppDefaults.defaults.set(jsonData, forKey: "location")
                AppDefaults.defaults.synchronize()
            }catch{
                print("location not save")
            }
        }
    }


}

