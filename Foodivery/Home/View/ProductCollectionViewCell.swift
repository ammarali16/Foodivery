//
//  ProductCollectionViewCell.swift
//  Foodivery
//
//  Created by Admin on 2/7/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import UIKit
import SDWebImage

class ProductCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageViewProduct: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    func configureCell(product: Product) {
        
        //self.imageViewProduct.image = product.imageUrl
        imageViewProduct.sd_setImage(with: URL(string: product.imageUrl!), placeholderImage: UIImage(named: "slider_01"))
        self.priceLabel.text = String("$\(product.price)")
        self.nameLabel.text = product.name
        
    }

}
