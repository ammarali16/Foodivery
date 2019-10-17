//
//  Navigator.swift
//  Foodivery
//
//  Created by Admin on 2/4/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import Foundation
import UIKit
class Navigator {
    
    
    public static func gotoHomeScreen(navigationController: UINavigationController,animation: Bool = true){
        let vc = UIStoryboard.init(name: AppRouter.storyboarName, bundle: nil).instantiateViewController(withIdentifier: AppRouter.toHomeViewController) as! HomeViewController
        vc.isFromSplashScreen = false
        navigationController.pushViewController(vc, animated: animation)
    }
    
}
