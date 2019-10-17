//
//  DealsViewController.swift
//  Foodivery
//
//  Created by Admin on 12/31/18.
//  Copyright © 2018 Mujadidia Inc. All rights reserved.
//

import UIKit

class DealsViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var dealsArray = [Deals]()
    var isFavorite = false
    var isProduct = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDataFromCoreData()
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func loadDataFromCoreData(){
        
       
        self.dealsArray = CoreDataManager.shared.getAllDeals(predicate: nil)
        tableView.reloadData()
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
//    func checkIsFavorite(itemId: Int){
//        self.isFavorite = CoreDataManager.shared.checkAlreadyFavorite(itemId: itemId, isProduct: self.isProduct)
//        self.favoriteButton.setImage(self.isFavorite ? #imageLiteral(resourceName: "fill_star_icon") : #imageLiteral(resourceName: "unfill_star_icon"), for: .normal)
//    }
    
    func markAsFavorite(itemId: Int){
        
    
        if self.isFavorite {
            CoreDataManager.shared.deleteFavorite(itemId: itemId, isProduct: self.isProduct)
            self.tableView.reloadData()
            //self.checkIsFavorite(itemId: itemId)
        }else{
            let favId = Int(Date().getDateString(format: "yyMMddHHmmss"))!
            print("favId: \(favId)")
            let favorite = Favorite.init(id: favId, itemId: itemId, isProduct: self.isProduct)
            CoreDataManager.shared.addFavorite(favorite: favorite)
            self.tableView.reloadData()
            //self.checkIsFavorite(itemId: itemId)
        }
        
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        
        let btn = sender as! UIButton
        if let cell = btn.superview?.superview?.superview?.superview as? UITableViewCell {
            if let indexPath = self.tableView.indexPath(for: cell) {
                
                let itemId = self.dealsArray[indexPath.row].id
                self.isFavorite = CoreDataManager.shared.checkAlreadyFavorite(itemId: itemId, isProduct: self.isProduct)
                 print("favorite: \(isFavorite)")
                self.markAsFavorite(itemId: itemId)
            }
        }
    }
    
    
    
}

extension DealsViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dealsArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dealcell", for: indexPath) as! DealsTableViewCell
        let deal = dealsArray[indexPath.row]
        cell.configureCell(deal: deal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let deal = self.dealsArray[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let foodItemViewController = storyboard.instantiateViewController(withIdentifier: "toFoodItemDetailViewController") as! FoodItemDetailViewController
        foodItemViewController.deal = deal
        self.show(foodItemViewController, sender: nil)
    }
    
}
