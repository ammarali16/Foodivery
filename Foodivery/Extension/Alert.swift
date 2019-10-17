//
//  Alerts.swift
//  Islamic Center App
//
//  Created by Ammar on 12/22/17.
//  Copyright © 2017 Mujadidia. All rights reserved.
//

import UIKit

class Alert {
    
    public static func showAlert(vc: UIViewController, title:  String, message: String, actionTitle : String = "OK", handler: ((UIAlertAction) -> ())? = nil ) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let alertActionOK = UIAlertAction.init(title: actionTitle, style: UIAlertActionStyle.default, handler: handler)
        alertController.addAction(alertActionOK)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    public static func showConfirmationAlert(vc: UIViewController, title:  String, message: String, actionTitle1 : String = "Yes", actionTitle2 : String = "Cancel", handler1: ((UIAlertAction) -> ())? = nil, handler2: ((UIAlertAction) -> ())? = nil ) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: self.checkIsiPad() ? .alert : .actionSheet)
        let alertActionYes = UIAlertAction.init(title: actionTitle1, style: UIAlertActionStyle.destructive, handler: handler1)
        let alertActionNo = UIAlertAction.init(title: actionTitle2, style: UIAlertActionStyle.cancel, handler: handler2)
        alertController.addAction(alertActionYes)
        alertController.addAction(alertActionNo)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    public static func showConfirmationAlertWithActionSheet(vc: UIViewController, title:  String, message: String, actionTitle1 : String = "Yes", actionTitle2 : String = "Cancel",actionTitle3 : String = "Cancel", handler1: ((UIAlertAction) -> ())? = nil, handler2: ((UIAlertAction) -> ())? = nil, handler3: ((UIAlertAction) -> ())? = nil) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: self.checkIsiPad() ? .alert : .actionSheet)
        let alertActionYes = UIAlertAction.init(title: actionTitle1, style: UIAlertActionStyle.default, handler: handler1)
        let alertActionNo = UIAlertAction.init(title: actionTitle2, style: UIAlertActionStyle.default, handler: handler2)
        let alertActionCancel = UIAlertAction.init(title: actionTitle3, style: UIAlertActionStyle.cancel, handler: handler3)
        alertController.addAction(alertActionYes)
        alertController.addAction(alertActionNo)
        alertController.addAction(alertActionCancel)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    public static func showConfirmationAlertWithAlert(vc: UIViewController, title:  String, message: String, actionTitle1 : String = "Yes", actionTitle2 : String = "Cancel",actionTitle3 : String = "Cancel", handler1: ((UIAlertAction) -> ())? = nil, handler2: ((UIAlertAction) -> ())? = nil, handler3: ((UIAlertAction) -> ())? = nil) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let alertActionYes = UIAlertAction.init(title: actionTitle1, style: UIAlertActionStyle.default, handler: handler1)
        let alertActionNo = UIAlertAction.init(title: actionTitle2, style: UIAlertActionStyle.default, handler: handler2)
        let alertActionCancel = UIAlertAction.init(title: actionTitle3, style: UIAlertActionStyle.cancel, handler: handler3)
        alertController.addAction(alertActionYes)
        alertController.addAction(alertActionNo)
        alertController.addAction(alertActionCancel)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    public static func gotoSettings(title: String, msg: String, viewController: UIViewController){
        
        let alertController = UIAlertController (title: title, message: msg, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    public static func checkIsiPad() -> Bool{
        return UI_USER_INTERFACE_IDIOM() == .pad
    }
    
    public static func showNoInternetAlert(vc: UIViewController){
        self.showAlert(vc: vc, title: "No Internet!", message: "Sorry! No internet connection found.")
    }
}
