//
//  Enumerations.swift
//  Foodivery
//
//  Created by Admin on 2/1/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import Foundation

enum HTTPResponseStatus: String {
    case error
    case success
}

enum UnitSystem: String {
    case metric
    case imperial
}


enum HTTPServices {
    case guestLogin
    case getRestaurantData
    case getAllProduct
    case getAllProductBySubcategory
    case registerUser
    case login
    case forgetPassword
    case getAllAddress
    case address
    case editAddress
    case deleteAddress
    case changePassword
    case setProfilePic
    case createOrder
    case editUser
    case verifyContact
    case registerDeviceFcm
    case getMyOrders
    case socialSingIn
    case logOut
    case googleDistanceApi
}


enum FormType {
    case signIn
    case signUp
    case forgotPassword
}



