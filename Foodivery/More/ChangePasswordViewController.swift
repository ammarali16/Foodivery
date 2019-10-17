//
//  ChangePasswordViewController.swift
//  Foodivery
//
//  Created by Admin on 3/23/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    
    @IBOutlet weak var tfCurrentPassword: UITextField!
    @IBOutlet weak var tfNewPassword: UITextField!
    @IBOutlet weak var tfReEnterPassword: UITextField!
    
    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var btnChangePasswordBottomConstraint: NSLayoutConstraint!
    var btnChangePasswordY: CGFloat?
    
    var viewModel: ProfileViewModel!
    
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
        self.btnChangePasswordY = self.btnChangePassword.frame.origin.y
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
    
    @IBAction func btnChangePasswordPressed(_ sender: Any) {
        self.changePassword()
    }
    
    
    func changePassword(){
        
        guard Connectivity.isConnectedToInternet() else {
            Alert.showNoInternetAlert(vc: self)
            return
        }
        
        if !tfCurrentPassword.hasText{
            tfCurrentPassword.shake()
        }else if !tfNewPassword.hasText{
            tfNewPassword.shake()
        }else if !tfReEnterPassword.hasText {
            tfReEnterPassword.shake()
        }else if self.tfNewPassword.text! != self.tfReEnterPassword.text! {
            Alert.showAlert(vc: self, title: "Passwords Not Matched!", message: "Your New Password and Retype New Password are not same.", handler: { action in
                self.tfNewPassword.shake()
                self.tfReEnterPassword.shake()
            })
            
        }else{
            
            if Connectivity.isConnectedToInternet() {
                Loader.showLoader(viewController: self)
                self.viewModel.changePassword(email: "abc@yopmail.com", current_password: tfCurrentPassword.text!, password: tfNewPassword.text!, confirm_password: tfReEnterPassword.text! )
            }else{
                
                Alert.showNoInternetAlert(vc: self)
            }
            
            
            
//            Loader.showLoader(viewController: self)
//            self.viewModel.changePassword(email: "abc@yopmail.com", current_password: tfCurrentPassword.text!, password: tfNewPassword.text!, confirm_password: tfReEnterPassword.text! )
        }
    }
    
}

//MARK: - HTTPResponseDelegate
extension ChangePasswordViewController: HTTPResponseDelegate {
    
    func httpRequestFinishWithSuccess(response: Any, service: HTTPServices) {
        
        Loader.dismissLoader(viewController: self)
        
        switch service {
            
        case .changePassword:
     
            if let msg = response as? String {
                Alert.showAlert(vc: self, title: "Success", message: msg )
            }
        default:
            print("nothing")
        }
    }
    
    func httpRequestFinishWithError(message: String, service: HTTPServices) {
        
        Loader.dismissLoader(viewController: self)
        
        switch service {
            
        case .changePassword:
            if let msg = message as? String {
                print(msg)
            Alert.showAlert(vc: self, title: "Error!", message: msg)
            }
        default:
            print("nothing")
        }
    }
    
    
}

extension ChangePasswordViewController {
    
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

        //                var contentInset:UIEdgeInsets = self.scrollView.contentInset
        //                contentInset.bottom = keyboardFrame.size.height
        //                scrollView.contentInset = contentInset

        if self.btnChangePassword.frame.origin.y == self.btnChangePasswordY! {
            self.btnChangePassword.frame.origin.y -= keyboardFrame.height
            self.btnChangePasswordBottomConstraint.constant -= keyboardFrame.height
        }

    }

    @objc func keyboardWillHide(notification: NSNotification) {
        //                let contentInset:UIEdgeInsets = .zero
        //                scrollView.contentInset = contentInset
        self.btnChangePassword.frame.origin.y = self.btnChangePasswordY!
        self.btnChangePasswordBottomConstraint.constant = 0
    }
}
