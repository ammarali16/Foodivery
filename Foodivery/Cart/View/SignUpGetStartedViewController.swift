//
//  GetStartedViewController.swift
//  Foodivery
//
//  Created by Admin on 1/2/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import UIKit

class SignUpGetStartedViewController: UIViewController {
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var contraintBottomSignUpView: NSLayoutConstraint!
    @IBOutlet weak var contraintBottomSignInView: NSLayoutConstraint!
    @IBOutlet weak var contraintBottomForgetPasswordView: NSLayoutConstraint!
    
    
    @IBOutlet weak var viewSignIn: UIView!
    @IBOutlet weak var viewForgotPassword: UIView!
    @IBOutlet weak var viewSignUp: UIView!
    
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var constraintBtnContinueBottomSpace: NSLayoutConstraint!
    var yPosition: CGFloat = 0.0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.registerKeyboardNotifications()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.transition(with: self.blurView, duration: 0.3, options: [.curveEaseIn], animations: {
                self.blurView.alpha = 1
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.deRegisterKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.yPosition = self.view.frame.origin.y
    }
    
    @IBAction func btndd(_ sender: Any) {
        UIView.transition(with: self.blurView, duration: 0.3, options: [.curveEaseIn], animations: {
            self.blurView.alpha = 0
        }) { (success) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func closeForgetPasswordButton(_ sender: Any) {
        hideForgetPasswordViewAndShowSignInView()
    }
    
    @IBAction func closeSignUpButton(_ sender: Any) {
        hideSignUpViewAndShowSignInView()
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        self.hideSignInViewAndShowSignUpView()
    }
    
    @IBAction func forgetPasswordButton(_ sender: Any) {
        hideSignInViewAndShowForgetPasswordView()
    }
}

extension SignUpGetStartedViewController {
    
    
    //MARK: - Hiding And Showing SignIn/SignUp Views
    
    func hideSignInViewAndShowSignUpView(){
        
        self.contraintBottomSignInView.constant = -450
        
        UIView.animate(withDuration: 0.1, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (success) in
            self.showSignUpView()
        })
        
    }
    
    func hideSignUpViewAndShowSignInView(){
        
        self.contraintBottomSignUpView.constant = -500
        
        UIView.animate(withDuration: 0.1, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (success) in
            self.showSignInView()
        })
        
    }
    
    func hideSignInViewAndShowForgetPasswordView(){
        
        self.contraintBottomSignInView.constant = -450
        
        UIView.animate(withDuration: 0.1, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (success) in
            self.showForgetPasswordView()
        })
        
    }
    
    func hideForgetPasswordViewAndShowSignInView(){
        
        self.contraintBottomForgetPasswordView.constant = -280
        
        UIView.animate(withDuration: 0.1, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (success) in
            self.showSignInView()
        })
        
    }
    
    func showSignUpView(){
        
        self.contraintBottomSignUpView.constant = 0
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func showForgetPasswordView(){
        
        self.contraintBottomForgetPasswordView.constant = 0
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func showSignInView(){
        
        self.contraintBottomSignInView.constant = 0
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
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
        
        if self.view.frame.origin.y == self.yPosition {
            self.view.frame.origin.y -= keyboardFrame.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != self.yPosition {
            self.view.frame.origin.y = self.yPosition
        }
    }
    
    
}

