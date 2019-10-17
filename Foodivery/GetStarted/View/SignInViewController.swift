//
//  LoginViewController.swift
//  Foodivery
//
//  Created by Admin on 3/13/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import UIKit
import MRProgress
import GoogleSignIn
import Firebase

class SignInViewController: UIViewController {
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var btnSignInBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var btnSignIn: UIButton!
    var btnSignInY: CGFloat?
    
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
        self.btnSignInY = self.btnSignIn.frame.origin.y
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.deRegisterKeyboardNotifications()
    }
    
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func forgotPasswordBtnPressed(_ sender: Any) {
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        let viewController =
            storyboard?.instantiateViewController(withIdentifier: "toSignUpViewController")
                as! SignUpViewController

        self.present(viewController, animated: true, completion: nil)
        
    }
    
    @IBAction func btnSignInPressed(_ sender: Any) {
        self.doLoginViaEmail()
        
    }
    @IBAction func unwindToLoginScreen(_ sender: UIStoryboardSegue){}
    
    
    @IBAction func facebookBtnPressed(_ sender: Any) {
        
        self.viewModel?.loginWithFacebook(vc: self)
        
    }
    
    @IBAction func googleBtnPressed(_ sender: Any) {
        Loader.showLoader(viewController: self)
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    
    @IBAction func gmailBtnPressed(_ sender: Any) {
    }
    @IBAction func forgetPasswordBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: AppRouter.toForgetPasswordViewController, sender: nil)
    }
    
    
    func doLoginViaEmail(){
        
        
        if !tfEmail.hasText{
            tfEmail.shake()
        } else if !tfPassword.hasText{
            tfPassword.shake()
        } else if !(tfEmail.text?.isEmail)!{
            Alert.showAlert(vc: self, title: "Error!", message: "Email address is not valid. It should be like abc@xyz.com") { (action) in
                self.tfEmail.shake()
            }
        }else{
            
            self.view.endEditing(true)
            
            if Connectivity.isConnectedToInternet() {
                Loader.showLoader(viewController: self)
                self.viewModel.loginUser(email: self.tfEmail.text!, password: self.tfPassword.text!)
            }else{
                
                    Alert.showNoInternetAlert(vc: self)
            }
            
//            Loader.showLoader(viewController: self)
//            self.viewModel.loginUser(email: self.tfEmail.text!, password: self.tfPassword.text!)
        }
    }
    
}

//MARK: - GIDSignInDelegate, GIDSignInUIDelegate
extension SignInViewController: GIDSignInDelegate, GIDSignInUIDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        Loader.dismissLoader(viewController: self)
        if let error = error {
            print("google error: \(error.localizedDescription)")
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        self.firebaseLogin(credential)
    }
    
    func firebaseLogin(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                Alert.showAlert(vc: self, title: "Google Login Error!", message: error.localizedDescription)
                return
            }
            if let displayName = user?.displayName, let email = user?.email, let userId = user?.uid {
                var photoURL = ""
                if user?.photoURL != nil {
                    photoURL = (user?.photoURL?.absoluteString)!
                }
                print("signIn: displayName: \(String(describing: displayName)), email: \(String(describing: email)), uid: \(String(describing: userId)), photo: \(String(describing: photoURL))")
                Loader.showLoader(viewController: self)
                self.viewModel?.socialSignIn(id: userId, name: displayName, email: email, image: photoURL)
            }else{
                Alert.showAlert(vc: self, title: "Error!", message: "In fatched information, something missing. You can not login with this account.")
            }
        }
    }
}




//MARK: - HTTPResponseDelegate
extension SignInViewController: HTTPResponseDelegate {
    
    func httpRequestFinishWithSuccess(response: Any, service: HTTPServices) {
        
        Loader.dismissLoader(viewController: self)
        
        switch service {
            
        case .login, .socialSingIn :
            
            //self.performSegue(withIdentifier: AppRouter.toPaymentViewController, sender: nil)
            print("APPDEFAULTS FCM TOKEN: \(AppDefaults.fcmToken)")
            
            self.viewModel.registerDeviceFcm(fcm_token: AppDefaults.fcmToken, platform: "ios")
            NotificationCenter.default.post(name: .goToPaymentScreen, object: nil)
           
            case .registerDeviceFcm :
            
                if let msg = response as? String{
                    print("Device: \(msg)")
            }
            
        default:
            print("nothing")
        }
    }
    
    func httpRequestFinishWithError(message: String, service: HTTPServices) {
        
        Loader.dismissLoader(viewController: self)
        
        switch service {
            
        case .login, .socialSingIn:
            
        
            
            if let msg = message as? String{
                //Alert.showAlert(vc: self, title: "Error!", message: message)
                Alert.showAlert(vc: self, title: "Error!", message: msg)
            }
        default:
            print("nothing")
        }
    }
}

extension SignInViewController {
    
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
        
        if self.btnSignIn.frame.origin.y == self.btnSignInY! {
            self.btnSignIn.frame.origin.y -= keyboardFrame.height
            self.btnSignInBottomSpace.constant -= keyboardFrame.height
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
//                let contentInset:UIEdgeInsets = .zero
//                scrollView.contentInset = contentInset
        self.btnSignIn.frame.origin.y = self.btnSignInY!
        self.btnSignInBottomSpace.constant = 0
    }
}
