//
//  PaymentTableViewCell.swift
//  Foodivery
//
//  Created by Admin on 3/27/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    
    func configureCell(cartObject: Cart){
        
        if cartObject.isProduct == true{
            self.settingProductValues(product: cartObject.product)
            
        }else {
            self.settingDealValues(deal: cartObject.deal)
            
        }
        
        self.quantityLabel.text = String(cartObject.quantity)
        
    }
    
    func settingProductValues(product: Product?){
        
        guard let product = product else {
            return
        }
        
        self.titleLabel.text = product.name
        self.paymentLabel.text = String("$\(product.price)")
        
    }
    
    func settingDealValues(deal: Deals?){
        
        guard let deal = deal else {
            return
        }
        
        self.titleLabel.text = deal.name
        self.paymentLabel.text = String("$\(deal.price)")
    }
    
    
}
