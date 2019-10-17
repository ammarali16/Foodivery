//
//  CategoryModel.swift
//  Foodivery
//
//  Created by Admin on 2/4/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import Foundation

struct Category: Codable {

    let id: Int
    let restaurant_id: Int
    let name: String
    let description: String?
    let imageUrl: String?
    let sub_categories: [SubCategory]
    
}
