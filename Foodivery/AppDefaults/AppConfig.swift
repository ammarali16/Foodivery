//
//  AppConfig.swift
//  Foodivery
//
//  Created by Admin on 1/11/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//


import Foundation
import UIKit

class AppConfig {
    
    
    public static let restaurantId = "1"
    
    //MARK: - Base URL
    
    public static let BASE_URL = "http://192.168.18.10/restaurant-delivery-system/public/api/" //Local Server
    //public static let BASE_URL = "https://internal.mujadidia.com/restaurant-api/api/" //Staging Server
    
    //MARK: - API Keys
 
    //public static let googleMapKey = "AIzaSyCPDl4rGZVwR8NOw9AXY6pphmaFr6PXeMU"
    public static let googleMapKey = "AIzaSyASCuq2OGHBoJZ8WNAc5XlRX9_qLDX8-KU"
    public static let googleSignInKey = "304443097251-9fclbssr30j2e0sg35ubgao6htvnm34c.apps.googleusercontent.com"
    public static let directionApiKey = "AIzaSyCwhW0kRpnnMJ0TiKc2A60JqtJqEOIVMm0"

    //MARK: - CREDENTIALS
    
    public static let email = "guest@yopmail.com"
    public static let password =  "123456"
    
    
    public static let PRIVACY_POLICY_URL = "https://www.islamiccenterapps.com/privacy-policy/"
    public static let TERMS_CONDITIONS_URL = "https://www.islamiccenterapps.com/terms-and-conditions/"
}
