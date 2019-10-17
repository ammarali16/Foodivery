//
//  AddNewAddressViewController.swift
//  Foodivery
//
//  Created by Admin on 3/19/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import UIKit


class AddNewAddressViewController: UIViewController {

   
    @IBOutlet weak var tvTitle: UITextView!
    @IBOutlet weak var tvAddress: UITextView!
    @IBOutlet weak var tvStreet: UITextView!
    @IBOutlet weak var tvFloor: UITextView!
    @IBOutlet weak var tvArea: UITextView!
    
    
    @IBOutlet weak var btnSaveAddressBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnSave: UIButton!
    var btnSaveY: CGFloat?
    
    var viewModel: AddressViewModel!
    var passingItem: Address?
    var whichSeguePersorm = ""
     var addressArray = [Address]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewModel = AddressViewModelImp()
        self.viewModel.httpResponseHandler = self
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        self.registerKeyboardNotifications()
        setupUI()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.btnSaveY = self.btnSave.frame.origin.y
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
        self.deRegisterKeyboardNotifications()
         self.tabBarController?.tabBar.isHidden = false
    }
    
    func backButton(){
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
    }
    
    
    func saveAddress(){
        guard Connectivity.isConnectedToInternet() else {
            Alert.showNoInternetAlert(vc: self)
            return
        }
        
        if !tvTitle.hasText {
            tvTitle.shake()
        } else if !tvAddress.hasText{
            tvAddress.shake()
        } else if !tvStreet.hasText{
            tvStreet.shake()
        } else if !tvArea.hasText{
            tvArea.shake()
        }else if !tvFloor.hasText{
            tvFloor.shake()
        }
        else{
            
            if Connectivity.isConnectedToInternet() {
                Loader.showLoader(viewController: self)
                self.viewModel.userAddress(title: tvTitle.text!, address: tvAddress.text!, street: tvStreet.text!, area: tvArea.text!, floor: tvFloor.text!)
            }else{
                
                Alert.showNoInternetAlert(vc: self)
            }
            
            
        }
    }
    
    
    func editAddress(){
        if !tvTitle.hasText {
            tvTitle.shake()
        } else if !tvAddress.hasText{
            tvAddress.shake()
        } else if !tvStreet.hasText{
            tvStreet.shake()
        } else if !tvArea.hasText{
            tvArea.shake()
        }else if !tvFloor.hasText{
            tvFloor.shake()
        }
        else{
            
            if Connectivity.isConnectedToInternet() {
                Loader.showLoader(viewController: self)
                self.viewModel.editAddress(id: (passingItem?.id)! , title: tvTitle.text!, address: tvAddress.text!, street: tvStreet.text!, area: tvArea.text!, floor: tvFloor.text!)
            }else{
                
                Alert.showNoInternetAlert(vc: self)
            }
        }
    }
    
    
    
    
    func setupUI(){
        if self.whichSeguePersorm == "toUpdateAddAddressViewController"{
            self.navigationItem.title = "Update Address"
            self.tvTitle.text = passingItem?.title
            self.tvAddress.text = passingItem?.address
            self.tvStreet.text = passingItem?.street
            self.tvArea.text = passingItem?.area
            self.tvFloor.text = passingItem?.floor
        }else{
            self.navigationItem.title = passingItem?.title
        }
        
        backButton()
    }
    
    
    
    @IBAction func btnSaveAddressPressed(_ sender: Any) {
        
        if self.whichSeguePersorm == "toUpdateAddAddressViewController" {
            self.editAddress()
        } else{
            saveAddress()
        }
    }
    
}
    
//MARK: - HTTPResponseDelegate
 extension AddNewAddressViewController: HTTPResponseDelegate {
        
        func httpRequestFinishWithSuccess(response: Any, service: HTTPServices) {
            
            Loader.dismissLoader(viewController: self)
            
            switch service {
                
            case .address:
                
               
               
                
                if let msg = response as? String{
                    
                    Alert.showAlert(vc: self, title: "Success!", message: "Address Added Sucsessfully") { (action) in
                        
                        self.addressArray = CoreDataManager.shared.getAllAddress(predicate: nil)
                       
                        
                        
                        if  self.addressArray.count == 1 {
                            AppDefaults.defaultAddressId = self.addressArray[0].id
                            
                            let address = self.tvAddress.text!
                            let street = self.tvStreet.text!
                            let area = self.tvArea.text!
                            let floor = self.tvFloor.text!
                            
                            let combinedAddress = "\(address) \(street) \(area) \(floor)"
                            
                            AppDefaults.address = combinedAddress
                        }
                    
                            self.performSegue(withIdentifier: "toAddress", sender: self)
                        
                    }
                }
                
            case .editAddress:
                
                if let msg = response as? String{
                    Alert.showAlert(vc: self, title: "Success!", message: "Address Updated Sucsessfully") { (action) in
                        self.performSegue(withIdentifier: "toAddress", sender: self)
                    }
                }
                
                
            default:
                print("nothing")
            }
        }
        
        func httpRequestFinishWithError(message: String, service: HTTPServices) {
            
            Loader.dismissLoader(viewController: self)
            
            switch service {
                
            case .address:
                
                if let msg = message as? String{
                    //Alert.showAlert(vc: self, title: "Error!", message: message)
                    Alert.showAlert(vc: self, title: "Error!", message: msg)
                }
                
            case .editAddress:
                
                if let msg = message as? String{
                    //Alert.showAlert(vc: self, title: "Error!", message: message)
                    Alert.showAlert(vc: self, title: "Error!", message: msg)
                }
            default:
                print("nothing")
            }
        }
    }
    
extension AddNewAddressViewController {
    
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
        
        if self.btnSave.frame.origin.y == self.btnSaveY! {
            self.btnSave.frame.origin.y -= keyboardFrame.height
            self.btnSaveAddressBottomConstraint.constant -= keyboardFrame.height
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        //                let contentInset:UIEdgeInsets = .zero
        //                scrollView.contentInset = contentInset
        self.btnSave.frame.origin.y = self.btnSaveY!
        self.btnSaveAddressBottomConstraint.constant = 0
    }
}

