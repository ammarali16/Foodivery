//
//  FoodItemCell.swift
//  Foodivery
//
//  Created by Admin on 12/26/18.
//  Copyright © 2018 Mujadidia Inc. All rights reserved.
//

import UIKit

class FoodItemCell: UITableViewCell {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    @IBOutlet weak var labelSubcategoryTitle: UILabel!
    
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
    
    func configureCell(subCategory: SubCategory){
        self.labelSubcategoryTitle.text = subCategory.name
    }

}
