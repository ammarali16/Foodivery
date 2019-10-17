//
//  Sliders.swift
//  Foodivery
//
//  Created by Admin on 4/19/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import Foundation

struct Sliders: Codable {
    
    let id: Int
    let name: String?
    let description: String?
    let category_id: Int?
    let deal_id: Int?
    let sub_category_id: Int?
    let item_id: Int?
    let media: [SlidesImage]
    let sub_category: SubCategory?
    let item: Product?
    
}

struct SlidersTest: Codable {
    
    let id: Int
    let name: String?
    let description: String?
    let category_id: Int?
    let deal_id: Int?
    let sub_category_id: Int?
    let item_id: Int?
    let media: [SlidesImage]
    let sub_category: SubCategory?
    
}

