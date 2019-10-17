//
//  MoreViewController.swift
//  Foodivery
//
//  Created by Admin on 1/7/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {
    
    
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var logoutBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileViewHeightConstraint: NSLayoutConstraint!
    
    
    var viewModel: GetStartedViewModel!
    var fcmTken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton()
        
        self.viewModel = GetStartedViewModelImp()
        self.viewModel.httpResponseHandler = self
        
        self.addObservers()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.setupUI()
    }
    
    deinit {
        removeObservers()
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.segueToOrderScreen), name: NSNotification.Name.reloadOrdres, object: nil)
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: .reloadOrdres, object: nil)
    }
    
    
    @objc func segueToOrderScreen(){
        
        performSegue(withIdentifier: "toOrderStatusViewController", sender: nil)
        
    }
    
    func setupUI(){
        backButton()
        hideLogoutBtn()
        hideProfileView()
        self.fcmTken = AppDefaults.fcmToken
    }
    
    func hideLogoutBtn(){
        if AppDefaults.isLogin{
            self.logoutView.isHidden = false
            self.logoutBtnHeightConstraint.constant = 50
        }else{
            self.logoutView.isHidden = true
            self.logoutBtnHeightConstraint.constant = 0.0
            
        }
    }
    
    func hideProfileView(){
        if AppDefaults.isLogin {
            self.profileView.isHidden = false
            self.profileViewHeightConstraint.constant = 190
        }else{
            self.profileView.isHidden = true
            self.profileViewHeightConstraint.constant = 0
        }
        
    }
    
    func backButton(){
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
    }
    
    @IBAction func btnProfileInformation(_ sender: Any) {
        performSegue(withIdentifier: AppRouter.toProfileViewController, sender: nil)
    }
    
    @IBAction func btnMyOrders(_ sender: Any) {
        performSegue(withIdentifier: "toOrderStatusViewController", sender: nil)
    }
    
    @IBAction func btnAboutUs(_ sender: Any) {
        
    }
    
    
    @IBAction func btnFeedback(_ sender: Any) {
        
        
    }
    
    
    
    @IBAction func btnTermsConditionPressed(_ sender: Any) {
        guard let url = URL(string: AppConfig.TERMS_CONDITIONS_URL) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func btnPrivacyPolicyPressed(_ sender: Any) {
        guard let url = URL(string: AppConfig.PRIVACY_POLICY_URL) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func btnAddressBook(_ sender: Any) {
        performSegue(withIdentifier: "toAddressBookViewController", sender: nil)
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        
        Alert.showConfirmationAlert(vc: self, title: "Logout!", message: "Are you sure you want to logout?", actionTitle1: "Yes, Logout", handler1: { (action) in
            self.viewModel.logoutUser()
            self.hideProfileView()
            self.tabBarController?.selectedIndex = 0
        })
        
        
    }
    
    
}

//MARK: - HTTPResponseDelegate
extension MoreViewController: HTTPResponseDelegate {
    
    func httpRequestFinishWithSuccess(response: Any, service: HTTPServices) {
        
        Loader.dismissLoader(viewController: self)
        
        switch service {
            
        case .logOut:
            
            
              
                    let guestApiToken = AppDefaults.guestApiToken
                    AppDefaults.clearUserDefaults()
                    CoreDataManager.shared.deleteAllCart()
                    CoreDataManager.shared.deleteAllAddress()
                    CoreDataManager.shared.deleteAllOrders()
                    AppDefaults.isLogin = false
                    AppDefaults.guestApiToken = guestApiToken
                    self.hideLogoutBtn()
                    AppDefaults.fcmToken = self.fcmTken ?? ""
                
            
            
        default:
            print("nothing")
        }
    }
    
    func httpRequestFinishWithError(message: String, service: HTTPServices) {
        
        Loader.dismissLoader(viewController: self)
        
        switch service {
            
        case .logOut:
            
            if let msg = message as? String{
                print(msg)
                //Alert.showAlert(vc: self, title: "Error!", message: message)
                Alert.showAlert(vc: self, title: "Error!", message: msg)
            }
        default:
            print("nothing")
        }
    }
}
