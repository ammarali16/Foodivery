//
//  OrdersTableViewCell.swift
//  Foodivery
//
//  Created by Admin on 4/30/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import UIKit

class OrdersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderLbl: UILabel!
    @IBOutlet weak var orderPlacedLabel: UILabel!
    @IBOutlet weak var orderStatusLabel: UILabel!
    

    func configureCell(orderObject: Orders){
    
        orderLbl.text = String(orderObject.id)
        orderPlacedLabel.text = orderObject.delivery_time
        //orderStatusLabel.text = "\(String(describing: orderObject.status))"
        self.orderStatus(orderObject: orderObject)
    }
    
    func orderStatus(orderObject: Orders){
        
        if orderObject.status == 0 {
            orderStatusLabel.text = "Checking"
        } else if orderObject.status == 1  {
            orderStatusLabel.text = "Confirmed"
        } else if orderObject.status == 2 {
            orderStatusLabel.text = "Cancelled"
        } else if orderObject.status == 3 {
            orderStatusLabel.text = "Delivered"
        }
        
    }

}
