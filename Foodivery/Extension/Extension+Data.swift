//
//  Extension+Data.swift
//  Islamic Center App
//
//  Created by Ammar on 12/21/17.
//  Copyright © 2017 Mujadidia. All rights reserved.
//

import Foundation

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
