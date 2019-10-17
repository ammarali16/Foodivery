//
//  AddressViewController.swift
//  Foodivery
//
//  Created by Admin on 3/19/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import UIKit

class AddressViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var btnAddAddressBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnAddAddress: UIButton!
    var btnAddAddressY: CGFloat?
    
    var addressArray = [Address]()
    var viewModel: AddressViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.viewModel = AddressViewModelImp()
        self.viewModel.httpResponseHandler = self
        
        loadDataFromCoreData()
        backButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        self.registerKeyboardNotifications()
        //loadDataFromCoreData()
        backButton()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.btnAddAddressY = self.btnAddAddress.frame.origin.y
        //loadDataFromCoreData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.deRegisterKeyboardNotifications()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    func backButton(){
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
    }
    
    func loadDataFromCoreData(){
        
        if Connectivity.isConnectedToInternet() {
            Loader.showLoader(viewController: self)
            self.viewModel.getAllAddresses()
        }else{
            
            Alert.showNoInternetAlert(vc: self)
        }
        
        
        self.addressArray = CoreDataManager.shared.getAllAddress(predicate: nil)
        
        if self.addressArray.count == 1 {
            AppDefaults.defaultAddressId = self.addressArray[0].id
        }
        self.tableView.reloadData()
    }
    
    
    @IBAction func unwindToAddress(_ sender: UIStoryboardSegue){}
    
    
    
    @IBAction func btnAddAddress(_ sender: Any) {
        self.performSegue(withIdentifier: "toAddAddressViewController", sender: nil)
    }
    
        
    
    @IBAction func editButton(_ sender: Any) {
        
        let btn = sender as! UIButton
        guard let cell = btn.superview?.superview?.superview as? AddressTableViewCell else {
            return
        }
        
        let indexPath = self.tableView.indexPath(for: cell)
        
        Alert.showConfirmationAlertWithActionSheet(vc: self, title: "Choose An Option", message: "Edit or Delete Address", actionTitle1: "Edit", actionTitle2: "Delete", actionTitle3: "Cancel", handler1: { (action) in
            let passingAddress = self.addressArray[(indexPath?.row)!]
            self.performSegue(withIdentifier: "toUpdateAddAddressViewController", sender: passingAddress)
            
        }, handler2: { (action) in
            let addressId = self.addressArray[(indexPath?.row)!].id
            print("addressId: \(addressId)")
            self.viewModel.deleteAddress(addressId: addressId)
            self.loadDataFromCoreData()
            
            
            
        }) { (action) in
           
        }
        
    }
   

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toUpdateAddAddressViewController" {
            
            let destVc = segue.destination as! AddNewAddressViewController
            destVc.passingItem = sender as? Address
            destVc.whichSeguePersorm = "toUpdateAddAddressViewController"
            
        }
    }
}

extension AddressViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddressTableViewCell
        let address = addressArray[indexPath.row]
        cell.configureCell(obj: address)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let addressObject = self.addressArray[indexPath.row]
        
        AppDefaults.defaultAddressId = addressObject.id
        
        if let address = addressObject.address, let street = addressObject.street, let area = addressObject.area, let floor = addressObject.floor {
            let combinedAddress = "\(address)  \(street)  \(area)  \(floor)"
            AppDefaults.address = combinedAddress
        }
        
        tableView.reloadData()
    }
    
}


//MARK: - HTTPResponseDelegate
extension AddressViewController: HTTPResponseDelegate {
    
    func httpRequestFinishWithSuccess(response: Any, service: HTTPServices) {
        
        Loader.dismissLoader(viewController: self)
        
        switch service {
            
        case .address, .getAllAddress:
            
            self.addressArray = CoreDataManager.shared.getAllAddress(predicate: nil)
            self.tableView.reloadData()
            
        case .deleteAddress:
            
            
                
                Alert.showAlert(vc: self, title: "Success!", message: "Address Deleted Sucsessfully") { (action) in
                    
                    self.loadDataFromCoreData()
                    
                    if self.addressArray.count == 0 {
                        AppDefaults.address = ""
                    }
                  
                
                
            }
            
        default:
            print("nothing")
        }
    }
    
    func httpRequestFinishWithError(message: String, service: HTTPServices) {
        
        Loader.dismissLoader(viewController: self)
        
        switch service {
            
        case .deleteAddress:
            
            if let msg = message as? String{
                //Alert.showAlert(vc: self, title: "Error!", message: message)
                Alert.showAlert(vc: self, title: "Error!", message: msg)
                
            }
        default:
            print("nothing")
        }
    }
}


extension AddressViewController {
    
    //MARK: - Hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
        
        if self.btnAddAddress.frame.origin.y == self.btnAddAddressY! {
            self.btnAddAddress.frame.origin.y -= keyboardFrame.height
            self.btnAddAddressBottomConstraint.constant -= keyboardFrame.height
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        //                let contentInset:UIEdgeInsets = .zero
        //                scrollView.contentInset = contentInset
        self.btnAddAddress.frame.origin.y = self.btnAddAddressY!
        self.btnAddAddressBottomConstraint.constant = 0
    }
}
