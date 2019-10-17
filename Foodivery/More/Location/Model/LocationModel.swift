//
//  LocationModel.swift
//  Foodivery
//
//  Created by Admin on 5/24/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import Foundation

struct Location: Codable {
    var durationText: String
    var durationValue: Int
    var distanceText: String
    var distanceValue: Int
    var polyline: String
}
