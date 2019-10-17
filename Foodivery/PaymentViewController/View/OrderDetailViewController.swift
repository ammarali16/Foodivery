//
//  OrderDetailViewController.swift
//  Foodivery
//
//  Created by Admin on 4/12/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    var orderObject: Orders?
    var whichSeguePerform = ""
    
    var cartArray = [Cart]()
    var cellHeight: CGFloat!
    
    var totalPrice = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
         self.cartArray = CoreDataManager.shared.getAllCartItems(predicate: nil)
        setUpUI()
        print("orderObject: \(orderObject)")
    }
    
    
    
    func setUpUI(){
        
        self.cellHeight = 80
        self.tableViewHeightConstraint.constant = cellHeight * CGFloat(cartArray.count)
        
        if whichSeguePerform == "fromOrderStatus"{
            self.addressLabel.text = AppDefaults.address
            self.totalAmountLabel.text = orderObject?.total
        }else{
            self.addressLabel.text = AppDefaults.address
            self.totalAmountLabel.text  = String("$\(totalPrice)")
        }
        
        
       
        
    }
    
    @IBAction func unwindToHome(_ sender: Any) {
        
        let cartItems = self.cartArray
        
        for cartItem in cartItems {
        CoreDataManager.shared.deleteCart(itemId: cartItem.itemId, isProduct: cartItem.isProduct)
        }
        
        //self.performSegue(withIdentifier: "toHomeView", sender: self)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cartArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderDetailTableViewCell
        let cartObject = self.cartArray[indexPath.row]
        cell.configureCell(cartObject: cartObject)
        return cell
    }
    
}
