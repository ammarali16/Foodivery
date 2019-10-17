//
//  MenuViewController.swift
//  Foodivery
//
//  Created by Admin on 1/8/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import UIKit


class ItemsViewController: UIViewController {
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var subcategory: SubCategory!
    var productArray = [Product]()
    var viewModel: ItemsViewModel!
    var subcategoryName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.viewModel = ItemsViewModelImp()
        self.viewModel.httpResponseHandler = self
        
        self.collectionView.contentInset = UIEdgeInsets.init(top: 16, left: 16, bottom: 0, right: 16)
        fetchData()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setupUI(){
        
        self.title = subcategory.name
        self.subcategoryName = subcategory.name ?? ""
        
    }
    

    
    func fetchData(){
        
        self.loadDataFromCoreData()
        if Connectivity.isConnectedToInternet() {
            if self.productArray.count == 0 {
                Loader.showLoader(viewController: self)
            }
            self.viewModel.getAllItems(subcategoryId: subcategory.id)
        }else{
            if self.productArray.count == 0 {
                Alert.showNoInternetAlert(vc: self)
            }
        }
    }
    
    
    func loadDataFromCoreData(){
        
        self.productArray = CoreDataManager.shared.getAllProductsBySubCategory(id: (subcategory?.id)!)
        self.collectionView.reloadData()
        
    }
    
}

extension ItemsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productArray.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemCollectionViewCell

        let product = productArray[indexPath.row]
        cell.configureCell(product: product, subcategory: subcategory)
        cell.addShadow()
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let product = productArray[indexPath.row]
        self.performSegue(withIdentifier: AppRouter.toFoodItemDetailViewController, sender: product)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destVC = segue.destination as? FoodItemDetailViewController {
        
            destVC.product = sender as? Product
            destVC.subcategoryName = self.subcategoryName
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat =  42
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
        
    }
}

extension ItemsViewController: HTTPResponseDelegate {
    
    
    
    func httpRequestFinishWithSuccess(response: Any, service: HTTPServices) {
        
        Loader.dismissLoader(viewController: self)
        
        switch service {
 
        case .getAllProductBySubcategory:
            
            self.loadDataFromCoreData()
           
        default:
            print("nothing")
        }
    }
    
    func httpRequestFinishWithError(message: String, service: HTTPServices) {
        
        Loader.dismissLoader(viewController: self)
        
        switch service {
            
        case .getAllProductBySubcategory:
            Alert.showAlert(vc: self, title: "Error!", message: message)
        default:
            print("nothing")
        }
    }
    
}
