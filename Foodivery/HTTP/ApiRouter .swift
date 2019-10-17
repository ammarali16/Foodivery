//
//  ApiRouter .swift
//  Foodivery
//
//  Created by Admin on 2/1/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import Foundation


class ApiRouter {
    
    
    
    //MARK: - Google API's
    public static func googleDistanceApiURL(origin: String, destination: String, unit: String) -> String {
        return "https://maps.googleapis.com/maps/api/directions/json?\(unit)&origin=\(origin)&destination=\(destination)&key=\(AppConfig.directionApiKey)"
    }
    
    //MARK: - Home
    public static let loginGuestUser = AppConfig.BASE_URL + "login"
    public static let getRestaurantData = AppConfig.BASE_URL + "restaurant/data/1"
    public static let getAllProductBySubcategory = AppConfig.BASE_URL + "items/"
    public static let registerUser = AppConfig.BASE_URL + "register"
    public static let loginUser = AppConfig.BASE_URL + "login"
    public static let forgetPassword = AppConfig.BASE_URL + "user/forgot-password-request"
    public static let address = AppConfig.BASE_URL + "user/address"
    public static let editAddress = AppConfig.BASE_URL + "user/address/"
    public static let deleteAddress = AppConfig.BASE_URL + "user/address/"
    public static let changePassword = AppConfig.BASE_URL + "user/reset-password"
    public static let setProfilePic = AppConfig.BASE_URL + "user/image"
    public static let createOrder = AppConfig.BASE_URL + "order/v2/1"
    public static let editUser = AppConfig.BASE_URL + "user/edit"
    public static let registerDeviceFcm = AppConfig.BASE_URL + "user/register-device"
    public static let getOrdersData = AppConfig.BASE_URL + "user/orders"
    public static let socialSingIn = AppConfig.BASE_URL + "social-login"
    public static let logoutUser = AppConfig.BASE_URL + "user/logout/"
    public static let getAllAddresses = AppConfig.BASE_URL + "user/addresses"   
    
}
