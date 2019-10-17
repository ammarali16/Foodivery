//
//  CartViewController.swift
//  Foodivery
//
//  Created by Admin on 12/31/18.
//  Copyright © 2018 Mujadidia Inc. All rights reserved.
//

import UIKit
import CoreData


class CartViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var placeOrderButton: UIButton!
    @IBOutlet weak var noItemsInCartView: UIView!
    

    var cartArray = [Cart]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        loadDatafromCoreData()
        backButton()
        self.addObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDatafromCoreData()
        self.setTabBarVisible(visible: true, animated: false)
    }
    
    deinit {
        removeObservers()
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.goaToPaymentScreen), name: NSNotification.Name.goToPaymentScreen, object: nil)
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: .goToPaymentScreen, object: nil)
    }
    
    func backButton(){
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
    }
    
    func loadDatafromCoreData(){
        
        self.cartArray = CoreDataManager.shared.getAllCartItems(predicate: nil)
        setTotalSum()
        tableView.reloadData()
        self.noItemsInCartView.isHidden = self.cartArray.count > 0
    }
    
    
    @objc func goaToPaymentScreen(){
        self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: AppRouter.toPaymentViewController, sender: nil)
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
        buttonEnableDisable()

    }

    
    func buttonEnableDisable(){
        let total = getTotalSum()
        
        if total == 0 {
            self.placeOrderButton.isEnabled = false
        }else{
            self.placeOrderButton.isEnabled = true
        }
    }
    
    
    @IBAction func unwindToCart(_ sender: UIStoryboardSegue){}
    
    @IBAction func addButton(_ sender: Any) {
        
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
                loadDatafromCoreData()
            }
            
        }
        
    }
    
    @IBAction func minusButton(_ sender: Any) {
        
        let btn = sender as! UIButton
        if let cell = btn.superview?.superview?.superview as? UITableViewCell {
            if let indexPath = self.tableView.indexPath(for: cell) {
                print("indexPath: \(indexPath)")
                
                var quantity = self.cartArray[indexPath.row].quantity
                let cartId = self.cartArray[indexPath.row].id
                
                if quantity != 1{
                    quantity = quantity - 1
                    _ = CoreDataManager.shared.updateCartQuantity(cartId: cartId, quantity: quantity)
                    loadDatafromCoreData()
                }
            }
        }
    }
    
    
    @IBAction func presentSignInScreen(_ sender: Any) {
        
        if AppDefaults.isLogin {

             self.performSegue(withIdentifier: AppRouter.toPaymentViewController, sender: nil)
            
            
            
        }else{
            
            let viewController =
                storyboard?.instantiateViewController(withIdentifier: "toSignInViewController")
                    as! SignInViewController
            self.tabBarController?.present(viewController, animated: true, completion: nil)
        }
        
    }
    
}
extension CartViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartcell", for: indexPath) as! CartTableViewCell
        
        let cartItem = self.cartArray[indexPath.row]
        cell.configureCell(cart: cartItem)
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
                //self.cartArray = CoreDataManager.shared.getAllCartItems(predicate: nil)
                _ = CoreDataManager.shared.getAllCartItems(predicate: nil)
                 self.loadDatafromCoreData()
            }

//            self.tableView.reloadData()
//            setTotalSum()
            
            
        }
    }
    
}


