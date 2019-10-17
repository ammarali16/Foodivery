//
//  Orders.swift
//  Foodivery
//
//  Created by Admin on 4/22/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import Foundation

struct Orders: Codable {
    
    let id: Int
    let user_id: Int?
    let restaurant_id: Int?
    let user_address_id: Int?
    let delivery_time: String?
    let status: Int?
    let status_message: String?
    let created_at: String?
    let updated_at: String?
    let tax: String?
    let delivery_charges: String?
    let sub_total: String?
    let total: String?
    let order_items: [OrderItems]
    let address: Address?
    
    
   
}
