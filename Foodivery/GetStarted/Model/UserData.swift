//
//  UserModel.swift
//  Foodivery
//
//  Created by Admin on 3/15/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import Foundation


struct UserData: Codable {
    
//    var id: Int
//    var name: String
//    var email: String
//    var isVerified: Int?
//    var token: String
    
    var id: Int
    var imageUrl: String?
    var name: String?
    var isPhoneVerified: Int?
    var date_of_birth: String?
    var contact: String?
    var isVerified : Int?
    var email: String
}
