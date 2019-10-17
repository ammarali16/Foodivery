//
//  AddressModel.swift
//  Foodivery
//
//  Created by Admin on 3/19/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import Foundation

struct Address: Codable {
    
    var id: Int
    var title : String?
    var address : String?
    var street : String?
    var area : String?
    var floor : String?
}
