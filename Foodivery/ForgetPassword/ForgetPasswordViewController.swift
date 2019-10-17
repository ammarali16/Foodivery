//
//  ForgetPasswordViewController.swift
//  Foodivery
//
//  Created by Admin on 3/16/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: UIViewController {
    
    @IBOutlet weak var tfEmail: UITextField!
    
    var viewModel: GetStartedViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.viewModel = GetStartedViewModelImp()
        self.viewModel.httpResponseHandler = self
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func forgetPasswordBtnPressed(_ sender: Any) {
        if !tfEmail.hasText{
            tfEmail.shake()
        }else if !(tfEmail.text?.isEmail)!{
            Alert.showAlert(vc: self, title: "Error!", message: "Email address is not valid. It should be like abc@xyz.com") { (action) in
                self.tfEmail.shake() }
        }else{
            
            if Connectivity.isConnectedToInternet() {
                Loader.showLoader(viewController: self)
                self.viewModel.forgotPassword(email: self.tfEmail.text!)
            }else{
                
                Alert.showNoInternetAlert(vc: self)
            }
            
            
        }
    }
}

//MARK: - HTTPResponseDelegate
extension ForgetPasswordViewController: HTTPResponseDelegate {
    
    func httpRequestFinishWithSuccess(response: Any, service: HTTPServices) {
        
        Loader.dismissLoader(viewController: self)
        
        switch service {
            
        case .forgetPassword:
            
            if let msg = response as? String{
                Alert.showAlert(vc: self, title: "Success!", message: msg) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        default:
            print("nothing")
        }
    }
    
    func httpRequestFinishWithError(message: String, service: HTTPServices) {
        
        Loader.dismissLoader(viewController: self)
        
        switch service {
            
        case .login:
            
            if let msg = message as? String{
                //Alert.showAlert(vc: self, title: "Error!", message: message)
                Alert.showAlert(vc: self, title: "Error!", message: msg)
            }
        default:
            print("nothing")
        }
    }
}

extension ForgetPasswordViewController {
    
    //MARK: - Hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
