//
//  SignUpViewController.swift
//  Foodivery
//
//  Created by Admin on 3/13/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import UIKit
import MRProgress

typealias myDictionary = [String: String]

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfEmailAddress: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfReTypePassword: UITextField!
    
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnSignUpBottomSpace: NSLayoutConstraint!
    var btnSignUpY: CGFloat?
    
    
    var viewModel: GetStartedViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        self.viewModel = GetStartedViewModelImp()
        self.viewModel.httpResponseHandler = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.btnSignUpY = self.btnSignUp.frame.origin.y
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.deRegisterKeyboardNotifications()
    }
    
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "toCartView", sender: self)
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func btnSignUpPressed(_ sender: Any) {
        
        self.doSignUpViaEmail()
    }
    
    
    
    func doSignUpViaEmail(){
        
        if !self.tfUserName.hasText {
            tfUserName.shake()
        } else if !self.tfEmailAddress.hasText {
            tfEmailAddress.shake()
        } else if !self.tfPassword.hasText {
            tfPassword.shake()
        } else if !self.tfReTypePassword.hasText {
            tfReTypePassword.shake()
        } else if !(self.tfEmailAddress.text?.isEmail)! {
            Alert.showAlert(vc: self, title: "Invalid Email!", message: "Email address is not valid. It should be like abc@xyz.com") { (action) in
                self.tfEmailAddress.shake()
            }
        } else {

            if Connectivity.isConnectedToInternet() {
                Loader.showLoader(viewController: self)
                self.viewModel.registerUser(name: tfUserName.text!, email: tfEmailAddress.text!, password: tfPassword.text!, c_password: tfReTypePassword.text!)
            }else{
                
                Alert.showNoInternetAlert(vc: self)
            }

            
            
//            Loader.showLoader(viewController: self)
//            self.viewModel.registerUser(name: tfUserName.text!, email: tfEmailAddress.text!, password: tfPassword.text!, c_password: tfReTypePassword.text!)
            
            
        }
        
        
        
        
        
//        else {
//
//            let dictionary: myDictionary = [
//                "name":       self.tfUserName.text!,
//                "contact":    self.tfContactNumber.text!,
//                "email":      self.tfEmailAddress.text!,
//                "password":   self.tfPassword.text!,
//                "c_password": self.tfReTypePassword.text!
//
//            ]
//
//
//            performSegue(withIdentifier: "toPhoneVerificationViewController", sender: dictionary)
//        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destVC = segue.destination as? PhoneVerificationViewController{
            destVC.userDetail = sender as? myDictionary
        }
        
    }
}

//MARK: - HTTPResponseDelegate
extension SignUpViewController: HTTPResponseDelegate {
    
    func httpRequestFinishWithSuccess(response: Any, service: HTTPServices) {
        
        Loader.dismissLoader(viewController: self)
        
        switch service {
            
        case .registerUser:
            
            if let msg = response as? String {
                //Alert.showAlert(vc: self, title: "Success!", message: msg)
                Alert.showAlert(vc: self, title: "Success", message: msg) { (action) in
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
            
        case .registerUser:
            
            if let msg = message as? String{
                //Alert.showAlert(vc: self, title: "Error!", message: message)
                Alert.showAlert(vc: self, title: "Error!", message: msg)
            }
        default:
            print("nothing")
        }
    }
}


extension SignUpViewController {
    
    //MARK: - Hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func tapOnScrollView(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    //MARK: - Keyboard notification observer Methods
    fileprivate func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc fileprivate func deRegisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidHide, object: nil)
    }
    
    @objc fileprivate func keyboardWillShow(notification: NSNotification) {
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        //        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        //        contentInset.bottom = keyboardFrame.size.height
        //        scrollView.contentInset = contentInset
        
        if self.btnSignUp.frame.origin.y == self.btnSignUpY! {
            self.btnSignUp.frame.origin.y -= keyboardFrame.height
            self.btnSignUpBottomSpace.constant -= keyboardFrame.height
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        //        let contentInset:UIEdgeInsets = .zero
        //        scrollView.contentInset = contentInset
        self.btnSignUp.frame.origin.y = self.btnSignUpY!
        self.btnSignUpBottomSpace.constant = 0
    }
}
