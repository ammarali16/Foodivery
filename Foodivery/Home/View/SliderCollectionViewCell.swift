//
//  SliderCollectionViewCell.swift
//  Foodivery
//
//  Created by Admin on 6/26/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import UIKit

class SliderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configureCell(sliderObject: Sliders) {
        
        //self.imageViewProduct.image = product.imageUrl
        //imageLabel.sd_setImage(with: URL(string: product.imageUrl!), placeholderImage: UIImage(named: "slider_01"))
        
        self.categoryNameLabel.text = sliderObject.sub_category?.name
        self.nameLabel.text = sliderObject.name
        self.descriptionLabel.text = sliderObject.description
        self.priceLabel.text = String("$\(String(describing: sliderObject.item!.price))")
        
        for media in sliderObject.media{
            if let collection_name = media.collection_name, collection_name == "default" {
                if let imageUrl = media.url {
                    self.imageLabel.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "slider_01"))
                }
            }
        }
    }
    
}
