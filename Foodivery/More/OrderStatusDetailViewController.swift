//
//  OrderStatusDetailViewController.swift
//  Foodivery
//
//  Created by Admin on 5/15/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import UIKit

class OrderStatusDetailViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalPayment: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    var cartArray = [Cart]()
    var cellHeight: CGFloat!
    var orderObject: Orders!
    
    
    var totalPrice = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadData()
        setUpUI()
        
    }
    
    func setUpUI(){
        
        self.cellHeight = 50
        self.tableViewHeightConstraint.constant = cellHeight * CGFloat(orderObject.order_items.count)
        
            self.totalPayment.text = orderObject?.total
        
    }
    
    func loadData(){
       
        if let address = orderObject.address{
            let addressString = "\(address.title ?? "") \(address.address ?? "") \(address.street ?? "") \(address.area ?? "") \(address.floor ?? "")"
            self.addressLabel.text = addressString
            
        }
        
        //let addressObject = CoreDataManager.shared.getAddressById(addressId: orderObject.user_address_id!)
        
        
        print("AddressObject: \(orderObject.address)")

    }
    
}
extension OrderStatusDetailViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return self.orderObject.order_items.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderDetailTableViewCell
        let orderItem = self.orderObject.order_items[indexPath.row]
   
        cell.configureCell(snapshot: orderItem.snapshot)
        return cell
    }
    
}
