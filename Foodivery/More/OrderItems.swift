//
//  OrderItems.swift
//  Foodivery
//
//  Created by Admin on 4/22/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import Foundation

struct OrderItems: Codable {
    
    let id: Int
    let order_id: Int?
    let quantity: Int?
    let created_at: String?
    let item_id: Int?
    let deal_id: Int?
    let snapshot: String?
    
    
}

