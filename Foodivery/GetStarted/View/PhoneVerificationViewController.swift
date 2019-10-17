//
//  PhoneVerificationViewController.swift
//  Foodivery
//
//  Created by Admin on 3/14/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import UIKit
import MRProgress

class PhoneVerificationViewController: UIViewController {
    
    var userDetail: myDictionary!
   
    var textSms = 1234
  
    override func viewDidLoad() {
        super.viewDidLoad()

    
        
    }

    @IBAction func verificationBtnPressed(_ sender: Any) {
        
        
//        if textSms == 1234 {
//            if let name = self.userDetail["name"], let contact = self.userDetail["contact"], let email = self.userDetail["email"], let password = self.userDetail["password"], let c_password = self.userDetail["c_password"] {
//                Loader.showLoader(viewController: self)
//                self.viewModel.registerUser(name: name, email: email, password: password, c_password: c_password, isPhoneVerified: true, contact: contact)
//            }
//            
//        }
    }
}



extension PhoneVerificationViewController {
    
    //MARK: - Hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
