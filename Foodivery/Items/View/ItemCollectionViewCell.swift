//
//  ItemCollectionViewCell.swift
//  Foodivery
//
//  Created by Admin on 2/28/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewProduct: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var foodCategoryLabel: UILabel!
    
    

    
    func configureCell(product: Product, subcategory: SubCategory) {
        
        if product.imageUrl != nil {
            imageViewProduct.sd_setImage(with: URL(string: product.imageUrl!), placeholderImage: #imageLiteral(resourceName: "slider_01"))
        } else {
            self.imageViewProduct.image = #imageLiteral(resourceName: "slider_01")
        }
        self.priceLabel.text = String("$\(product.price)")
        self.nameLabel.text = product.name
        self.foodCategoryLabel.text = subcategory.name
       
    }
}
