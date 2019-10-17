//
//  VerifyContactNumberViewController.swift
//  Foodivery
//
//  Created by Admin on 3/30/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import UIKit
import Firebase

class VerifyContactNumberViewController: UIViewController {
    
    @IBOutlet weak var tfOtp1: UITextField!
    @IBOutlet weak var tfOtp2: UITextField!
    @IBOutlet weak var tfOtp3: UITextField!
    @IBOutlet weak var tfOtp4: UITextField!
    @IBOutlet weak var tfOtp5: UITextField!
    @IBOutlet weak var tfOtp6: UITextField!
    
    
    
    @IBOutlet weak var btnVerify: UIButton!
    @IBOutlet weak var btnVerfiyBottomConstraint: NSLayoutConstraint!
    var btnVerifyY: CGFloat?
    
    var viewModel: ProfileViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.setUI()
        
        self.viewModel = ProfileViewModelImp()
        self.viewModel.httpResponseHandler = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.btnVerifyY = self.btnVerify.frame.origin.y
        tfOtp1.becomeFirstResponder()
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
    
    
    func setUI(){
        
        backButton()
        
        self.tfOtp1.backgroundColor = UIColor.clear
        self.tfOtp2.backgroundColor = UIColor.clear
        self.tfOtp3.backgroundColor = UIColor.clear
        self.tfOtp4.backgroundColor = UIColor.clear
        self.tfOtp5.backgroundColor = UIColor.clear
        self.tfOtp6.backgroundColor = UIColor.clear
        
        
        addBottomBorderTo(textField: tfOtp1)
        addBottomBorderTo(textField: tfOtp2)
        addBottomBorderTo(textField: tfOtp3)
        addBottomBorderTo(textField: tfOtp4)
        addBottomBorderTo(textField: tfOtp5)
        addBottomBorderTo(textField: tfOtp6)
        
        self.tfOtp1.delegate = self
        self.tfOtp2.delegate = self
        self.tfOtp3.delegate = self
        self.tfOtp4.delegate = self
        self.tfOtp5.delegate = self
        self.tfOtp6.delegate = self
        
        
    }
    
    
    func addBottomBorderTo(textField: UITextField){
        
        let layer = CALayer()
        layer.backgroundColor = UIColor.gray.cgColor
        layer.frame = CGRect(x: 0.0, y: textField.frame.size.height - 2.0 , width: textField.frame.size.width, height: 2.0)
        textField.layer.addSublayer(layer)
        
        
    }
    
    
    
    @IBAction func changeNumberButtonPressed(_ sender: Any) {

        self.navigationController?.popViewController({
            let name = Notification.Name(rawValue:  changeNumberKey)
            NotificationCenter.default.post(name: name, object: nil)
            
            //self.performSegue(withIdentifier: "toContactView", sender: self)
        })
        
//        self.dismiss(animated: true) {
//            let name = Notification.Name(rawValue:  changeNumberKey)
//            NotificationCenter.default.post(name: name, object: nil)
//
//        }
        //self.performSegue(withIdentifier: "toContactView", sender: self)
        
    }
    
    
    @IBAction func verifyButtonPressed(_ sender: Any) {
        
        //self.performSegue(withIdentifier: "toProfileView", sender: self)
        let verificationCode = "\(tfOtp1.text!)\(tfOtp2.text!)\(tfOtp3.text!)\(tfOtp4.text!)\(tfOtp5.text!)\(tfOtp6.text!)"
        
        print(verificationCode)
        
        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: AppDefaults.verificationId, verificationCode: verificationCode)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
            if error != nil{
                
                print("error:\(error?.localizedDescription)")
                Alert.showAlert(vc: self, title: "Error!", message: error as? String ?? "Please Enter Verification Code")
                
            }else{
                
                print("Phone Number Verified")
                
                if Connectivity.isConnectedToInternet() {
                    
                    Loader.showLoader(viewController: self)
                    
                    self.viewModel.editUser(name: nil, isPhoneVerified: 1, contact: nil)
                    
                }else{
                    
                    Alert.showNoInternetAlert(vc: self)
                    
                }
                
            }
        }
        
    }
    
    
}

extension VerifyContactNumberViewController: UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if ((textField.text?.count)! < 1 ) && (string.count > 0) {
            
            if textField == tfOtp1 {
                tfOtp2.becomeFirstResponder()
            }
            
            if textField == tfOtp2 {
                tfOtp3.becomeFirstResponder()
            }
            
            if textField == tfOtp3 {
                tfOtp4.becomeFirstResponder()
            }
            
            if textField == tfOtp4 {
                tfOtp5.becomeFirstResponder()
            }
            
            if textField == tfOtp5 {
                tfOtp6.becomeFirstResponder()
            }
            
            if textField == tfOtp6 {
                tfOtp6.becomeFirstResponder()
            }
            
            textField.text = string
            return false
            
        } else if ((textField.text?.count)! >= 1) && (string.count == 0) {
            
            
            if textField == tfOtp2 {
                tfOtp1.becomeFirstResponder()
            }
            
            if textField == tfOtp3 {
                tfOtp2.becomeFirstResponder()
            }
            
            if textField == tfOtp4 {
                tfOtp3.becomeFirstResponder()
            }
            
            if textField == tfOtp5 {
                tfOtp4.becomeFirstResponder()
            }
            
            if textField == tfOtp6 {
                tfOtp5.becomeFirstResponder()
            }
            
            if textField == tfOtp1 {
                tfOtp1.becomeFirstResponder()
            }
            
            textField.text = ""
            return false
            
        } else if ((textField.text?.count)! >= 1){
            
            textField.text = string
            return false
        }
        
        return true
    }
    
}


//MARK: - HTTPResponseDelegate
extension VerifyContactNumberViewController: HTTPResponseDelegate {
    
    func httpRequestFinishWithSuccess(response: Any, service: HTTPServices) {
        
        Loader.dismissLoader(viewController: self)
        
        switch service {
            
        case .editUser:
            
            AppDefaults.isPhoneVerified = 1
            print("isPhoneVerified: \(AppDefaults.isPhoneVerified)")
            self.performSegue(withIdentifier: "toPaymentView", sender: self)
            
            
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


extension VerifyContactNumberViewController {
    
//    //MARK: - Hide keyboard
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
    
    @IBAction func tapOnScrollView(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    //MARK: - Keyboard notification observer Methods
    fileprivate func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
        
        
        
        if self.btnVerify.frame.origin.y == self.btnVerifyY! {
            self.btnVerify.frame.origin.y -= keyboardFrame.height
            self.btnVerfiyBottomConstraint.constant -= keyboardFrame.height
        }
        
    }
    
//    @objc func keyboardWillHide(notification: NSNotification) {
//                        //let contentInset:UIEdgeInsets = .zero
//                        //scrollView.contentInset = contentInset
//        self.btnVerify.frame.origin.y = self.btnVerifyY!
//        self.btnVerfiyBottomConstraint.constant = 0
//    }
}
