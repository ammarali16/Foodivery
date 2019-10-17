//
//  Loader.swift
//  Foodivery
//
//  Created by Admin on 2/1/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import Foundation
import MRProgress

class Loader {
    
    public static func showLoader(title: String = "Please wait...", viewController: UIViewController){
        MRProgressOverlayView.showOverlayAdded(to: viewController.view, title: title, mode: .indeterminateSmall, animated: true)
    }
    
    public static func dismissLoader(viewController: UIViewController){
        MRProgressOverlayView.dismissAllOverlays(for: viewController.view, animated: true)
    }
    
}
