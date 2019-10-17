//
//  ContactNumberViewController.swift
//  Foodivery
//
//  Created by Admin on 3/30/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import UIKit
import Firebase
import MRProgress


class ContactNumberViewController: UIViewController {
    
    @IBOutlet weak var tfPhoneNumber: UITextField!
    
    @IBOutlet weak var btnSaveContact: UIButton!
    @IBOutlet weak var btnSaveContactBottomConstraint: NSLayoutConstraint!
    
    var btnSaveContactY: CGFloat?
    
    var viewModel: ProfileViewModel!
    var isFromPayment = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.viewModel = ProfileViewModelImp()
        self.viewModel.httpResponseHandler = self
        
        backButton()
        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.registerKeyboardNotifications()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.btnSaveContactY = self.btnSaveContact.frame.origin.y
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.deRegisterKeyboardNotifications()
    }
    
    
    func backButton(){
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
    }
    
    @IBAction func unwindToContact(_ sender: UIStoryboardSegue){}
    
    @IBAction func savePhoneNoButtonPressed(_ sender: Any) {
        
        if !(self.tfPhoneNumber.text?.isPhone)! {
            
            Alert.showAlert(vc: self, title: "Invalid Phone Number!", message: "Phone Number is not valid. It should be like +923333664334") { (action) in
                self.tfPhoneNumber.shake()
            }
            
        } else {
            
            if self.isFromPayment {
                
                //updateAndVerifyNumber()
                
                if Connectivity.isConnectedToInternet() {
                    
                    Loader.showLoader(viewController: self)
                    
                    self.viewModel.editUser(name: nil, isPhoneVerified: 0, contact: self.tfPhoneNumber.text!)
                    
                }else{
                    
                    Alert.showNoInternetAlert(vc: self)
                    
                }
                
            } else{
                print("whichSegue: \(self.isFromPayment)")
                updateNumber()
            }
            
        }
        
    }
    
    
    
    func sendOtpCode(){
        
        
        guard let phoneNumber = tfPhoneNumber.text else{
            return
        }
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationId, error) in
            
            if error == nil {
                
                AppDefaults.verificationId = verificationId!
                
                let vId = AppDefaults.verificationId
                print("Verification: \(vId)")
                
                
                
            }else {
                
                print("Error: \(error?.localizedDescription)")
                
            }
        }
        
    }
    
    
    func updateNumber(){
        
        guard let phoneNumber = tfPhoneNumber.text else{
            return
        }
        
        if Connectivity.isConnectedToInternet() {
            
            Loader.showLoader(viewController: self)
            
            self.viewModel.editUser(name: nil, isPhoneVerified: 0, contact: self.tfPhoneNumber.text!)
            
            
        }else{
            
            Alert.showNoInternetAlert(vc: self)
            
        }
        
    }
    
    
//    func enterPhoneNumber(){
//
//        if !(self.tfPhoneNumber.text?.isPhone)! {
//
//            Alert.showAlert(vc: self, title: "Invalid Phone Number!", message: "Phone Number is not valid. It should be like +923333664334") { (action) in
//                self.tfPhoneNumber.shake()
//            }
//        } else {
//
//            //            guard let oldUserData = AppDefaults.userData else {return}
//            //
//            //            let newUserData = UserData.init(id: oldUserData.id, imageUrl: oldUserData.imageUrl, name: oldUserData.name, isPhoneVerified: oldUserData.isPhoneVerified, role: oldUserData.role, date_of_birth: oldUserData.date_of_birth, contact: self.tfPhoneNumber.text, isVerified: oldUserData.isVerified, email: oldUserData.email)
//            //
//            //            AppDefaults.userData = newUserData
//
//
//
//            self.performSegue(withIdentifier: AppRouter.toVerifyContactViewController , sender: nil)
//        }
//
//    }
    
}


//MARK: - HTTPResponseDelegate
extension ContactNumberViewController: HTTPResponseDelegate {
    
    func httpRequestFinishWithSuccess(response: Any, service: HTTPServices) {
        
        Loader.dismissLoader(viewController: self)
        
        switch service {
            
        case .editUser:
            
            
            if self.isFromPayment{
                
                AppDefaults.isPhoneVerified = 0
                self.sendOtpCode()
                self.performSegue(withIdentifier: AppRouter.toVerifyContactViewController , sender: nil)

                
            } else {
            Alert.showAlert(vc: self, title: "Success!", message: "Phone Number Updated Successfully") { (action) in
                AppDefaults.isPhoneVerified = 0
                self.performSegue(withIdentifier: "toProfileView", sender: self)
            }
        }
            
            
        default:
            print("nothing")
        }
    }
    
    func httpRequestFinishWithError(message: String, service: HTTPServices) {
        
        Loader.dismissLoader(viewController: self)
        
        switch service {
            
        case .editUser:
            
            if let msg = message as? String{
                //Alert.showAlert(vc: self, title: "Error!", message: message)
                Alert.showAlert(vc: self, title: "Error!", message: msg)
            }
        default:
            print("nothing")
        }
    }
}

extension ContactNumberViewController {
    
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
        
        if self.btnSaveContact.frame.origin.y == self.btnSaveContactY! {
            self.btnSaveContact.frame.origin.y -= keyboardFrame.height
            self.btnSaveContactBottomConstraint.constant -= keyboardFrame.height
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        //        let contentInset:UIEdgeInsets = .zero
        //        scrollView.contentInset = contentInset
        self.btnSaveContact.frame.origin.y = self.btnSaveContactY ?? 0
        self.btnSaveContactBottomConstraint.constant = 0
    }
}
