//
//  OrderDetailTableViewCell.swift
//  Foodivery
//
//  Created by Admin on 4/12/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    
    
    func configureCell(snapshot: String?){
        guard let snapshot = snapshot else {
            return
        }
        
        if let decodedDataString = snapshot.data(using: .utf8){
            
            let jsonObject = JSON(decodedDataString)
            self.titleLabel.text = jsonObject["name"].stringValue
            self.paymentLabel.text = "$" + "\(jsonObject["price"].intValue)"
            
            
        }
        
        
    }
    
    
    func configureCell(cartObject: Cart){
        
        if cartObject.isProduct == true{
            self.settingProductValues(product: cartObject.product)
            
        }else {
            self.settingDealValues(deal: cartObject.deal)
            
        }
      
        
    }
    
    func settingProductValues(product: Product?){
        
        guard let product = product else {
            return
        }
        
        self.titleLabel.text = product.name
        self.paymentL	abel.text = String("$\(product.price)")
        
    }
    
    func settingDealValues(deal: Deals?){
        
        guard let deal = deal else {
            return
        }
        
        self.titleLabel.text = deal.name
        self.paymentLabel.text = String("$\(deal.price)")
    }

}
