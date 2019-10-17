//
//  HomeViewController.swift
//  Islamic Center App
//
//  Created by Ammar on 11/28/17.
//  Copyright © 2017 Mujadidia. All rights reserved.
//

import Foundation
import UIKit

public extension UITextField {

    public func clear() {
        text = ""
        attributedText = NSAttributedString(string: "")
    }
    
    public func setPlaceHolderColor(_ color: UIColor) {
    
        guard let holder = placeholder, !holder.isEmpty else {
            return
        }
        
        self.attributedPlaceholder = NSAttributedString(string: holder, attributes: [NSAttributedStringKey.foregroundColor: color])
    }
    
}
