//
//  DealsTableViewCell.swift
//  Foodivery
//
//  Created by Admin on 3/6/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import UIKit
import SDWebImage

class DealsTableViewCell: UITableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dealImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var isFavorite = false
    var isProduct = false
    
    func configureCell(deal: Deals){
        
        self.priceLabel.text = String("$\(deal.price)")
        self.nameLabel.text = deal.name
        self.descriptionLabel.text = deal.description
       
        if deal.imageUrl != nil {
            dealImageView.sd_setImage(with: URL(string: deal.imageUrl!), placeholderImage: #imageLiteral(resourceName: "slider_01"))
        } else {
            self.dealImageView.image = #imageLiteral(resourceName: "slider_01")
        }
        print("favorite: \(isFavorite)")
        checkIsFavorite(itemId: deal.id)
    }
    
    func configureCell(product: Product){
        
        self.priceLabel.text = String("$\(product.price)")
        self.nameLabel.text = product.name
        self.descriptionLabel.text = product.description
        
        if product.imageUrl != nil {
            dealImageView.sd_setImage(with: URL(string: product.imageUrl!), placeholderImage: #imageLiteral(resourceName: "slider_01"))
        } else {
            self.dealImageView.image = #imageLiteral(resourceName: "slider_01")
        }
       
    }
    
    
    func checkIsFavorite(itemId: Int){
        self.isFavorite = CoreDataManager.shared.checkAlreadyFavorite(itemId: itemId, isProduct: self.isProduct)
        print("favorite: \(isFavorite)")
        self.favoriteButton.setImage(self.isFavorite ? #imageLiteral(resourceName: "fill_star_icon") : #imageLiteral(resourceName: "unfill_star_icon"), for: .normal)
    }
    
}
