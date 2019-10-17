//
//  Cart.swift
//  Foodivery
//
//  Created by Admin on 3/11/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import Foundation


struct Cart: Codable {
    
    var id: Int
    var itemId: Int
    var isProduct: Bool
    var quantity: Int
    var product: Product?
    var deal: Deals?
}


