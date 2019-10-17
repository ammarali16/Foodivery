//
//  FavoriteViewController.swift
//  Foodivery
//
//  Created by Admin on 12/28/18.
//  Copyright © 2018 Mujadidia Inc. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDealView: UIView!
    @IBOutlet weak var noProductView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var favoriteProductsArray = [Product]()
    var favortieDealsArray = [Deals]()
    
    var isProduct = true
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupNavbar()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadData()
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func segmentViewValueChanged(_ sender: Any) {
        self.loadData()
    }
    
    func loadData(){
        if segmentView.selectedSegmentIndex == 0 {
            loadFavoriteProducts()
        }else{
            loadFavoriteDeals()
        }
    }
    
    func loadFavoriteProducts(){
        self.favoriteProductsArray = CoreDataManager.shared.getFavoriteProducts()
        self.tableView.reloadData()
        self.noDealView.isHidden = true
        self.noProductView.isHidden = self.favoriteProductsArray.count > 0
    }
    
    func loadFavoriteDeals(){
        self.favortieDealsArray = CoreDataManager.shared.getFavoriteDeals()
        self.tableView.reloadData()
        self.noProductView.isHidden = true
        self.noDealView.isHidden = self.favortieDealsArray.count > 0
    }
    
    
    func markAsFavorite(itemId: Int){
       
         if self.segmentView.selectedSegmentIndex == 0 {
        
            self.isProduct = true
            CoreDataManager.shared.deleteFavorite(itemId: itemId, isProduct: self.isProduct)
            self.favoriteProductsArray = CoreDataManager.shared.getFavoriteProducts()
            self.tableView.reloadData()
         } else{
            self.isProduct = false
            CoreDataManager.shared.deleteFavorite(itemId: itemId, isProduct: self.isProduct)
            self.favortieDealsArray = CoreDataManager.shared.getFavoriteDeals()
            print(favortieDealsArray)
            self.tableView.reloadData()
        }
        
    }
    
    @IBAction func favoriteButton(_ sender: Any) {
        
        
        if self.segmentView.selectedSegmentIndex == 0 {
            
            let btn = sender as! UIButton
            if let cell = btn.superview?.superview?.superview?.superview as? UITableViewCell {
                if let indexPath = self.tableView.indexPath(for: cell) {
                    
                    let itemId = self.favoriteProductsArray[indexPath.row].id
                    self.markAsFavorite(itemId: itemId)
                    
                }
                
            }
            
        }else{
            
            let btn = sender as! UIButton
            if let cell = btn.superview?.superview?.superview?.superview as? UITableViewCell {
                if let indexPath = self.tableView.indexPath(for: cell) {
                    
                    let itemId = self.favortieDealsArray[indexPath.row].id
                    self.markAsFavorite(itemId: itemId)
                    
                }
                
            }
            
        }

        
    }
    
    
    
}
extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segmentView.selectedSegmentIndex == 0 {
            return self.favoriteProductsArray.count
        }else{
            return self.favortieDealsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritecell", for: indexPath) as! DealsTableViewCell
        
        if self.segmentView.selectedSegmentIndex == 0 {
            cell.configureCell(product: self.favoriteProductsArray[indexPath.row])
        }else{
            cell.configureCell(deal: self.favortieDealsArray[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if  segmentView.selectedSegmentIndex == 0 {
            let product = self.favoriteProductsArray[indexPath.row]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let foodItemDetailViewController = storyboard.instantiateViewController(withIdentifier: "toFoodItemDetailViewController") as! FoodItemDetailViewController
            foodItemDetailViewController.product = product
            self.show(foodItemDetailViewController, sender: nil)
            
        } else{
            
            let deal = self.favortieDealsArray[indexPath.row]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let foodItemDetailViewController = storyboard.instantiateViewController(withIdentifier: "toFoodItemDetailViewController") as! FoodItemDetailViewController
            foodItemDetailViewController.deal = deal
            self.show(foodItemDetailViewController, sender: nil)
        }
    }
    
}
