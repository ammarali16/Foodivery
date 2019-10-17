//
//  SplashViewController.swift
//  Foodivery
//
//  Created by Admin on 2/1/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    var viewModel: HomeViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.viewModel = HomeViewModelImp()
        self.viewModel.httpResponseHandler = self
        
        
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        //self.performSegue(withIdentifier: "toDashboardViewController", sender: self)
        //setSplashOrDasboard()
    }
    
    func fetchData(){
        
        //performSegue()
        if AppDefaults.apiToken.isEmpty {
            guard Connectivity.isConnectedToInternet() else {
                performSegue()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    Alert.showNoInternetAlert(vc: self)
                }
                return
            }
            self.viewModel.loginGuestUser()
        } else{
            performSegue()
        }
    }
    
    
    func performSegue(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
            self.performSegue(withIdentifier: AppRouter.toHomeViewController, sender: self)
        }
    }
    
    //    func setupUI(){
    //        UIView.transition(with: self.view, duration: 1, options: [.curveEaseIn], animations: {
    //
    //        }, completion: { success in
    //            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
    //                self.setSplashOrDasboard()
    //            }
    //        })
    //
    //    }
    
    //    func setSplashOrDasboard() {
    //        if AppDefaults.apiToken.isEmpty {
    //            self.viewModel.registerUser()
    //        } else{
    //            self.performSegue(withIdentifier: "toDashboardViewController", sender: self)
    //        }
    //    }
}

//MARK: - HTTPResponseDelegate
extension SplashViewController: HTTPResponseDelegate {
    
    func httpRequestFinishWithSuccess(response: Any, service: HTTPServices) {
        
        Loader.dismissLoader(viewController: self)
        
        switch service {
            
        case .guestLogin:
            
            self.performSegue(withIdentifier: AppRouter.toHomeViewController, sender: self)
           
            
        default:
            print("nothing")
            
        }
    }
    
    func httpRequestFinishWithError(message: String, service: HTTPServices) {
        
        Loader.dismissLoader(viewController: self)
        
        switch service {
        case .guestLogin, .getRestaurantData:
            Alert.showAlert(vc: self, title: "Error!", message: message)
        default:
            print("nothing")
        }
    }
}
