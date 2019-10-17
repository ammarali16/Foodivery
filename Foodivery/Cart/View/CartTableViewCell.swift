//
//  CartTableViewCell.swift
//  Foodivery
//
//  Created by Admin on 3/11/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var dealImageView: UIImageView!
    @IBOutlet weak var quantityLabel: UILabel!
    
 
    
    func configureCell(cart: Cart){
        
        if cart.isProduct == true {
            self.settingProductValue(product: cart.product)
            self.quantityLabel.text = String(cart.quantity)
            
            
           
        }else{
            self.settingDealsValue(deal: cart.deal)
            self.quantityLabel.text = String(cart.quantity)
            
        }
        
    }
    
    func settingProductValue(product: Product?){
       
        guard let product = product else {
            return
        }
        
        self.priceLabel.text = String("$\(product.price)")
        self.nameLabel.text = product.name
        

        
        if product.imageUrl != nil {
            dealImageView.sd_setImage(with: URL(string: product.imageUrl!), placeholderImage: #imageLiteral(resourceName: "slider_01"))
        } else {
            self.dealImageView.image = #imageLiteral(resourceName: "slider_01")
        }
        
    }
    
    
    func settingDealsValue(deal: Deals?){
        
        guard let deal = deal else {
            return
        }
        
        self.priceLabel.text = String("$\(deal.price)")
        self.nameLabel.text = deal.name
        
        if deal.imageUrl != nil {
            dealImageView.sd_setImage(with: URL(string: deal.imageUrl!), placeholderImage: #imageLiteral(resourceName: "slider_01"))
        } else {
            self.dealImageView.image = #imageLiteral(resourceName: "slider_01")
        }
        
    }
    
}
