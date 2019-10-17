//
//  HorizontalMenuCollectionViewCell.swift
//  Foodivery
//
//  Created by Admin on 2/7/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import UIKit

class HorizontalMenuCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var horizontalMenuView: UIView!
    
    
    //MARK: - Configure Cell
    
    func configureCell(category: Category, isSelected: Bool) {
        self.labelTitle.text = category.name
        
        if isSelected {
            horizontalMenuView.backgroundColor = UIColor(red:0.89, green:0.11, blue:0.33, alpha:1.0)
            labelTitle.textColor = UIColor.white
        }else{
            horizontalMenuView.backgroundColor = UIColor.lightGray
            labelTitle.textColor = UIColor.black
        }
    } 
}
