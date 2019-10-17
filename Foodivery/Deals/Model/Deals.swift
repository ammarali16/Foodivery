//
//  Deals.swift
//  Foodivery
//
//  Created by Admin on 3/6/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import Foundation

struct Deals: Codable {
    
    var id: Int
    var restaurant_id: Int
    var name: String
    var description: String?
    var imageUrl: String?
    var price: Int
    
}
