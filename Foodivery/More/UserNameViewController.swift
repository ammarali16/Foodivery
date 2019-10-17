//
//  UserNameViewController.swift
//  Foodivery
//
//  Created by Admin on 3/30/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import UIKit

class UserNameViewController: UIViewController {

    @IBOutlet weak var tfUserName: UITextField!
    
    @IBOutlet weak var btnSaveUser: UIButton!
    @IBOutlet weak var btnSaveUserBottomConstraint: NSLayoutConstraint!
    var btnSaveUserY: CGFloat?
    
    
    
    var viewModel: ProfileViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        self.viewModel = ProfileViewModelImp()
        self.viewModel.httpResponseHandler = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.registerKeyboardNotifications()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.btnSaveUserY = self.btnSaveUser.frame.origin.y
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.deRegisterKeyboardNotifications()
    }
    
    func setUI(){
        self.tfUserName.text = AppDefaults.userData?.name
        backButton()
    }
    
    func backButton(){
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        self.enterName()
    }
    
    
    func enterName(){
        
        if tfUserName.text == "" {
            
            Alert.showAlert(vc: self, title: "Enter Name", message: "Please Enter Name") { (action) in
                self.tfUserName.shake()
            }
            
        }else{
            
            if Connectivity.isConnectedToInternet() {
                
                Loader.showLoader(viewController: self)
                
                self.viewModel.editUser(name: tfUserName.text, isPhoneVerified: nil, contact: nil)
                
                
            }else{
                
                Alert.showNoInternetAlert(vc: self)
                
            }
            
        }
        
    }
    
    
    
}


//MARK: - HTTPResponseDelegate
extension UserNameViewController: HTTPResponseDelegate {
    
    func httpRequestFinishWithSuccess(response: Any, service: HTTPServices) {
        
        Loader.dismissLoader(viewController: self)
        
        switch service {
            
        case .editUser:
            
            Alert.showAlert(vc: self, title: "Success!", message: "User Name Updated Successfully") { (action) in
                self.performSegue(withIdentifier: "toProfileView", sender: self)
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
extension UserNameViewController {
    
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
        
        if self.btnSaveUser.frame.origin.y == self.btnSaveUserY! {
            self.btnSaveUser.frame.origin.y -= keyboardFrame.height
            self.btnSaveUserBottomConstraint.constant -= keyboardFrame.height
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        //        let contentInset:UIEdgeInsets = .zero
        //        scrollView.contentInset = contentInset
        self.btnSaveUser.frame.origin.y = self.btnSaveUserY!
        self.btnSaveUserBottomConstraint.constant = 0
    }
}
