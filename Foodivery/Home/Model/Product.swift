//
//  ProductModel.swift
//  Foodivery
//
//  Created by Admin on 2/4/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import Foundation

struct Product: Codable {
    
    let id: Int
    let sub_category_id: Int?
    let name: String
    let description: String?
    let imageUrl: String?
    let price: Int
    
}
