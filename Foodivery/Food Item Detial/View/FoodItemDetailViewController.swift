//
//  FoodItemDetailViewController.swift
//  Foodivery
//
//  Created by Admin on 12/26/18.
//  Copyright © 2018 Mujadidia Inc. All rights reserved.
//

import UIKit
import SDWebImage

class FoodItemDetailViewController: UIViewController {
    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    
    
    var product: Product?
    var deal: Deals?
    var item: Product?
    var subCategory: SubCategory?
    
    var subcategoryName = ""
    
    var isProduct = true
    var isFavorite = false
    
    var quantity = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        setProductValues()
        setDealValues()
        loadShadow()
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadShadow(){
        
        self.detailView.addShadow()
    }
    
    
    @IBAction func addButton(_ sender: Any) {
        self.quantity = quantity + 1
        self.quantityLabel.text = String(quantity)
        
    }
    
    @IBAction func minusButton(_ sender: Any) {
        
        if self.quantity != 1 {
            self.quantity = quantity - 1
            self.quantityLabel.text = String(quantity)
        }
    }
    
    
    func setProductValues(){
        
        guard let product = self.product else {
            return
        }
        
        self.isProduct = true
        
        if product.imageUrl != nil {
            imageView.sd_setImage(with: URL(string: product.imageUrl!), placeholderImage: #imageLiteral(resourceName: "slider_01"))
        } else {
            self.imageView.image = #imageLiteral(resourceName: "slider_01")
        }
        self.nameLabel.text = product.name
        self.priceLabel.text = String("$\(product.price) Per Serving")
        self.descriptionLabel.text = product.description
        self.categoryLabel.text = subcategoryName
        
        self.checkIsFavorite(itemId: product.id)
        
    }
    
    func setDealValues(){
        
        guard let deal = self.deal else {
            return
        }
        
        self.isProduct = false
        
        if deal.imageUrl != nil {
            imageView.sd_setImage(with: URL(string: deal.imageUrl!), placeholderImage: #imageLiteral(resourceName: "slider_01"))
        } else {
            self.imageView.image = #imageLiteral(resourceName: "slider_01")
        }
        self.nameLabel.text = deal.name
        self.priceLabel.text = String("$\(deal.price) Per Serving")
        self.descriptionLabel.text = deal.description
        self.categoryLabel.text = subcategoryName
        
        self.checkIsFavorite(itemId: deal.id)
    }
    
    func checkIsFavorite(itemId: Int){
        self.isFavorite = CoreDataManager.shared.checkAlreadyFavorite(itemId: itemId, isProduct: self.isProduct)
        self.favoriteButton.setImage(self.isFavorite ? #imageLiteral(resourceName: "fill_star_icon") : #imageLiteral(resourceName: "unfill_star_icon"), for: .normal)
    }
    
    @IBAction func btnFavoritePressed(_ sender: Any) {
        
        if self.isProduct {
            let itemId = (self.product?.id)!
            self.markAsFavorite(itemId: itemId)
        }else{
            let itemId = (self.deal?.id)!
            self.markAsFavorite(itemId: itemId)
        }
        
    }
    
    func markAsFavorite(itemId: Int){
        if self.isFavorite {
            CoreDataManager.shared.deleteFavorite(itemId: itemId, isProduct: self.isProduct)
            self.checkIsFavorite(itemId: itemId)
        }else{
            let favId = Int(Date().getDateString(format: "yyMMddHHmmss"))!
            let favorite = Favorite.init(id: favId, itemId: itemId, isProduct: self.isProduct)
            CoreDataManager.shared.addFavorite(favorite: favorite)
            self.checkIsFavorite(itemId: itemId)
        }
    }
    
    
    @IBAction func addToCartBtn(_ sender: Any) {
        
        if self.isProduct{
            let itemId = (self.product?.id)!
            self.addItemToCart(itemId: itemId)
        } else {
            let itemId = (self.deal?.id)!
            self.addItemToCart(itemId: itemId)
        }
        
    }
    
    
    func addItemToCart(itemId: Int){
        
        let cartId = Int(Date().getDateString(format: "yyMMddHHmmss"))!
        let quantity = self.quantity
        
        if isProduct {
            product =  CoreDataManager.shared.getProductById(productId: itemId)
        }else{
            deal = CoreDataManager.shared.getDealsById(dealId: itemId)
        }
        
        
        if var cartObject = CoreDataManager.shared.getCartByItemId(itemId: itemId, isProduct: self.isProduct)
        {
            cartObject.quantity += self.quantity
            let isSuccess = CoreDataManager.shared.updateCart(cart: cartObject)
            if isSuccess {
                Alert.showAlert(vc: self, title: "Success!", message: "Added to cart successfully.")
            }else{
                Alert.showAlert(vc: self, title: "Error!", message: "Something went wrong.")
            }
        }
        else{
            
            let cartItem = Cart.init(id: cartId, itemId: itemId, isProduct: self.isProduct, quantity: quantity, product: product, deal: deal)
            CoreDataManager.shared.addToCart(cart: cartItem)
            Alert.showAlert(vc: self, title: "Success!", message: "Added to cart successfully.")
        }
    }
    
    
}

