//
//  PaymentViewController.swift
//  Foodivery
//
//  Created by Admin on 3/18/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import UIKit
import Firebase


let changeNumberKey = "co.changeNumber"

class PaymentViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfContactNumber: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var paymentOption: UITextField!

    
    var cartArray = [Cart]()
    var cellHeight: CGFloat!
    
    var viewModel: PaymentViewModel!
    var totalAmount: Int?
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.viewModel = PaymentViewModelImp()
        self.viewModel.httpResponseHandler = self
        
        cartTotal()
        setUpUI()
        createObserver()
        //setTotalSum()
        
    }
    
 
    
    
    let changeNumber = Notification.Name(rawValue: changeNumberKey)
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func createObserver(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(PaymentViewController.goToChangeNumber(notification:)), name: changeNumber, object: nil)
        
    }
    
    
    @objc func goToChangeNumber(notification: NSNotification){
        
        //self.performSegue(withIdentifier: "toContactNumberViewController", sender: nil)
        
        let storyboard = UIStoryboard(name: "More", bundle: nil)
        
        let customViewController = storyboard.instantiateViewController(withIdentifier: "toContactNumberViewController") as! ContactNumberViewController
        
        //customViewController.isFromPayment = true
        
        //self.show(customViewController, sender: nil)
        self.navigationController?.pushViewController(customViewController)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        cartTotal()
        setUpUI()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    func backButton(){
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
    }
    
    func cartTotal(){
        
        self.cartArray = CoreDataManager.shared.getAllCartItems(predicate: nil)
        setTotalSum()
        tableView.reloadData()
        
    }
    
    func tableViewHeight(){
        self.cellHeight = 100
        self.tableViewHeightContraint.constant = cellHeight * CGFloat(cartArray.count)
    }
    
    func setUpUI(){
        
        tableViewHeight()
        
        let address = AppDefaults.address
        self.tfAddress.text = address.isEmpty ? "Enter Address" : address
        
        if let phoneNumber = AppDefaults.userData?.contact {
            self.tfContactNumber.text = phoneNumber
        }else{
            self.tfContactNumber.text = "Enter Number"
        }
        
        self.paymentOption.text = "Cash On Delivery"
        
        
        backButton()
        
    }
    
    
    func getTotalSum() -> Int{
        
        var total = 0
        
        for cart in cartArray {
            
            if cart.isProduct {
                if let product = cart.product{
                    total += cart.quantity * product.price
                }
            }else{
                
                if let deal = cart.deal{
                    total += cart.quantity * deal.price
                }
            }
        }
        return total
    }
    
    
    func setTotalSum(){
        
        let total = getTotalSum()
        self.totalLabel.text = " $\(total)"
        
        self.totalAmount = total
    }
    
    
    @IBAction func unwindToPayment(_ sender: UIStoryboardSegue){}
    
    @IBAction func addressButtonPressed(_ sender: Any) {
        
        
        
        let storyboard = UIStoryboard(name: "More", bundle: nil)
        
        // Instantiate the desired view controller from the storyboard using the view controllers identifier
        // Cast is as the custom view controller type you created in order to access it's properties and methods
        let customViewController = storyboard.instantiateViewController(withIdentifier: "toAddressBookViewController") as! AddressViewController
        
        self.show(customViewController, sender: nil)
        
    }
    
    
    @IBAction func contactButtonPressed(_ sender: Any) {
        
        
        if self.tfContactNumber.hasText && AppDefaults.isPhoneVerified == 0 && self.tfContactNumber.text != "Enter Number" {
            
            let storyboard = UIStoryboard(name: "More", bundle: nil)
           
            let customViewController = storyboard.instantiateViewController(withIdentifier: "toVerifyContactViewController") as! VerifyContactNumberViewController
            
            //customViewController.isFromPayment = true
            
            self.show(customViewController, sender: nil)
            
            self.sendOtpCode()
            
        } else {
        
        let storyboard = UIStoryboard(name: "More", bundle: nil)
        
        // Instantiate the desired view controller from the storyboard using the view controllers identifier
        // Cast is as the custom view controller type you created in order to access it's properties and methods
        

        let customViewController = storyboard.instantiateViewController(withIdentifier: "toContactNumberViewController") as! ContactNumberViewController
        
        customViewController.isFromPayment = true
        
        self.show(customViewController, sender: nil)
            
        }
        
    }
    
    
    @IBAction func placeOrderButtonPressed(_ sender: Any) {
        
//        var items = [Product]()
//        var deals = [Deals]()
//        
//        for cart in self.cartArray {
//            if cart.isProduct {
//                
//                guard let product = cart.product else{
//                    return
//                }
//                    items.append(product)
//    
//            }else{
//                guard let deal = cart.deal else {
//                    return
//                }
//                deals.append(deal)
//            }
//        }
        
//        self.viewModel.createOrder(delivery_time: "2018-10-12 09:08:12", user_address_id: AppDefaults.defaultAddressId , payment_method: 1, cartArray: self.cartArray)
        
        
        checkOrderDetails()
        
    }
    
    
    func sendOtpCode(){
        
        
        guard let phoneNumber = tfContactNumber.text else{
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

    
    func checkOrderDetails(){
        
        
        if self.tfAddress.text == "Enter Address" {
            
            tfAddress.shake()
        }
        else if !self.tfContactNumber.hasText {
            
            tfContactNumber.shake()
            
        }
        else if AppDefaults.isPhoneVerified == 0  {
            
            
            
            Alert.showAlert(vc: self, title: "Phone Not Verified!", message: "Please Verify Your Phone Number.") { (action) in
                
                self.sendOtpCode()
                
                let storyboard = UIStoryboard(name: "More", bundle: nil)
                
                let customViewController = storyboard.instantiateViewController(withIdentifier: "toVerifyContactViewController") as! VerifyContactNumberViewController
                
                self.show(customViewController, sender: nil)
                
            }
            
            
            
        }
        else {
            print(AppDefaults.isPhoneVerified)
            Loader.showLoader(viewController: self)
            self.viewModel.createOrder(delivery_time: "2018-10-12 09:08:12", user_address_id: AppDefaults.defaultAddressId , payment_method: 1, cartArray: self.cartArray)
            
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        let btn = sender as! UIButton
        if let cell = btn.superview?.superview?.superview as? UITableViewCell {
            if let indexPath = self.tableView.indexPath(for: cell) {
                print("indexPath: \(indexPath)")
                
                var quantity = self.cartArray[indexPath.row].quantity
                print(quantity)
                let cartId = self.cartArray[indexPath.row].id
                print(cartId)
                
                quantity = quantity +  1
                
                
                _ = CoreDataManager.shared.updateCartQuantity(cartId: cartId, quantity: quantity)
                self.cartTotal()
                
            }
            
        }
    }
    
    @IBAction func minusButtonPressed(_ sender: Any) {
        
        let btn = sender as! UIButton
        if let cell = btn.superview?.superview?.superview as? UITableViewCell {
            if let indexPath = self.tableView.indexPath(for: cell) {
                print("indexPath: \(indexPath)")
                
                var quantity = self.cartArray[indexPath.row].quantity
                let cartId = self.cartArray[indexPath.row].id
                
                if quantity != 1{
                    quantity = quantity - 1
                    _ = CoreDataManager.shared.updateCartQuantity(cartId: cartId, quantity: quantity)
                    cartTotal()
                }
            }
        }
    }
    
    
}

extension PaymentViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cartArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PaymentTableViewCell
        let cartObject = self.cartArray[indexPath.row]
        cell.configureCell(cartObject: cartObject)
        return cell
    }
    
    
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            
            if editingStyle == .delete {
                let cartItem = self.cartArray[indexPath.row]
                CoreDataManager.shared.deleteCart(itemId: cartItem.itemId, isProduct: cartItem.isProduct)
                self.cartArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                _ = CoreDataManager.shared.getAllCartItems(predicate: nil)
                self.cartTotal()
                tableViewHeight()
                
                if cartArray.count <= 0 {
                    self.performSegue(withIdentifier: "toCartView", sender: self)
                }
            }
            
        }
    }
    
}

//MARK: - HTTPResponseDelegate
extension PaymentViewController: HTTPResponseDelegate {
    
    func httpRequestFinishWithSuccess(response: Any, service: HTTPServices) {
        
        Loader.dismissLoader(viewController: self)
        
        switch service {
            
        case .createOrder:
            
            
//            if let msg = response as? String {
//            Alert.showAlert(vc: self, title: "Success!", message: msg)
//            }
            
            let storyboard = UIStoryboard(name: "Cart", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "toOrderDetailView") as! OrderDetailViewController
            controller.totalPrice = self.totalAmount!
            self.present(controller, animated: true) {
                self.navigationController?.popViewController(animated: true)
                self.tabBarController?.selectedIndex = 0
            }
         
           
            
        default:
            print("nothing")
        }
    }
    
    func httpRequestFinishWithError(message: String, service: HTTPServices) {
        
        Loader.dismissLoader(viewController: self)
        
        switch service {
            
        case .createOrder:
            
            Alert.showAlert(vc: self, title: "Error!", message: message)
        default:
            print("nothing")
        }
    }
    
    
}

