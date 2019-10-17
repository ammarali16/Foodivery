//
//  GlobalSharedResources.swift
//  Foodivery
//
//  Created by Admin on 2/4/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import Foundation
import UIKit


class GlobalSharedResources {
    
    //MARK: - Check screen
    public static var isIphone: Bool {
        get {
            return UIDevice.current.userInterfaceIdiom == .phone ? true : false
        }
    }
    
}
