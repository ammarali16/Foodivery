//
//  HomeViewController.swift
//  Foodivery
//
//  Created by Admin on 12/17/18.
//  Copyright © 2018 Mujadidia Inc. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionViewMenu: UICollectionView!
    @IBOutlet weak var collectionViewSlider: UICollectionView!
    @IBOutlet weak var collectionViewProduct: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var homeView: UIScrollView!
    
    @IBOutlet weak var pageController: UIPageControl!
    
    @IBOutlet weak var constraintTableViewHeight: NSLayoutConstraint!
    
    var selectedCategoryIndexPath: IndexPath?
    
    var viewModel: HomeViewModel!
    var categoriesArray = [Category]()
    var slidersArray = [Sliders]()
    
    var subcategoryName = ""
    
    let cellHeight: CGFloat = 240
    
    var isFromSplashScreen = false
    
    
    var sliderIndex = 0
    var timer: Timer?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = HomeViewModelImp()
        self.viewModel.httpResponseHandler = self
        self.addObservers()
        
        fetchData()
        setupUI()
        //loadHomeData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        startTimer()
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timer?.invalidate()
    }
    
    
    deinit {
        removeObservers()
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.segueToOrderScreen), name: NSNotification.Name.reloadOrdres, object: nil)
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: .reloadOrdres, object: nil)
    }
    
    
    @objc func segueToOrderScreen(){
        
        let storyboard = UIStoryboard(name: "More", bundle: nil)
        
        let customViewController = storyboard.instantiateViewController(withIdentifier: "MyOrdersViewController") as! MyOrdersViewController
        
        self.show(customViewController, sender: nil)
        
    }
    
    func startTimer(){
        
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(runSlider), userInfo: nil, repeats: true)
        
    }
    
    
    func fetchData(){
        self.loadDataFromCoreData()
        
        if Connectivity.isConnectedToInternet() {
            if self.categoriesArray.count == 0 {
                Loader.showLoader(viewController: self)
            }
            self.viewModel.getRestaurantData()
        }else{
            if self.categoriesArray.count == 0 {
                Alert.showNoInternetAlert(vc: self)
            }
        }
    }
    
    
    func loadDataFromCoreData(){
        
        self.pageController.numberOfPages = self.slidersArray.count
        
        self.categoriesArray = CoreDataManager.shared.getAllCateogries()
        
        
        if self.categoriesArray.count > 0 {
            let firstCatId = self.categoriesArray[0].id
            self.slidersArray = CoreDataManager.shared.getAllSliders(predicate: NSPredicate.init(format: "category_id == %d", firstCatId))
            self.pageController.numberOfPages = slidersArray.count
        }
        
        
        if self.selectedCategoryIndexPath == nil {
            self.selectedCategoryIndexPath = IndexPath.init(row: 0, section: 0)
        }
        
        self.collectionViewMenu.reloadData()
        self.collectionViewSlider.reloadData()
        self.tableView.reloadData()
        
        guard self.categoriesArray.count > 0 else {
            return
        }
        self.constraintTableViewHeight.constant = CGFloat(self.categoriesArray[0].sub_categories.count) * cellHeight
    }
    
    func setupUI(){
        
        if AppDefaults.apiToken.isEmpty && AppDefaults.guestApiToken.isEmpty {
            noDataView.isHidden = false
            homeView.isHidden = true
        } else{
            noDataView.isHidden = true
            homeView.isHidden = false
        }
        
        
    }
    
    func loadHomeData(){
        Loader.showLoader(viewController: self)
        self.viewModel.getRestaurantData()
    }
    
    @IBAction func unwindToHome(_ sender: UIStoryboardSegue){}
    
    @IBAction func refreshButton(_ sender: Any) {
        
        guard Connectivity.isConnectedToInternet() else {
            Alert.showNoInternetAlert(vc: self)
            return
        }
        
        Loader.showLoader(viewController: self)
        self.viewModel.loginGuestUser()
    }
    
    @IBAction func viewAllButton(_ sender: Any) {
        
        let btn = sender as! UIButton
        if let cell = btn.superview?.superview?.superview as? UITableViewCell {
            if let indexPath = self.tableView.indexPath(for: cell) {
                
                let subcategory = self.categoriesArray[(self.selectedCategoryIndexPath?.row)!].sub_categories[indexPath.row]
                
                self.performSegue(withIdentifier: AppRouter.toItemsViewController, sender: subcategory)
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destVC = segue.destination as? ItemsViewController {
            destVC.subcategory = sender as? SubCategory
        }
        
        if let destVC = segue.destination as? FoodItemDetailViewController {
            destVC.product = sender as? Product
            destVC.item = sender as? Product
            destVC.subcategoryName = subcategoryName
           
        }
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
    }
    
    
    @objc func runSlider(){
  
        if self.sliderIndex < self.slidersArray.count, self.slidersArray.count != 0 {

            let indexPath = IndexPath.init(row: self.sliderIndex, section: 0)
            self.collectionViewSlider.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.pageController.currentPage = indexPath.row
            self.sliderIndex = self.sliderIndex < (self.slidersArray.count - 1) ? self.sliderIndex + 1 : 0
        }
        
    }
    
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.categoriesArray.count > 0 {
            let count = self.categoriesArray[(self.selectedCategoryIndexPath?.row)!].sub_categories.count
            return count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "subcategorycell",for: indexPath) as! FoodItemCell
        let subcategory = self.categoriesArray[(self.selectedCategoryIndexPath?.row)!].sub_categories[indexPath.row]
        cell.configureCell(subCategory: subcategory)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? FoodItemCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
    
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectionViewMenu {
            return self.categoriesArray.count
        }else if collectionView == self.collectionViewSlider {
            return self.slidersArray.count
        } else {
            let category = self.categoriesArray[(self.selectedCategoryIndexPath?.row)!]
            let products = category.sub_categories[collectionView.tag].five_items
            return (products?.count)!
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionViewMenu {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "horizontalmenucell", for: indexPath) as! HorizontalMenuCollectionViewCell
            
            let isSelected = (self.selectedCategoryIndexPath?.row)! == indexPath.row
            
            cell.configureCell(category: self.categoriesArray[indexPath.row], isSelected: isSelected)
            return cell
            
        }else if collectionView == self.collectionViewSlider{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "slidercell", for: indexPath) as! SliderCollectionViewCell
            cell.configureCell(sliderObject: self.slidersArray[indexPath.row])
            
            return cell
            
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productcell", for: indexPath) as! ProductCollectionViewCell
            
            let category = self.categoriesArray[(self.selectedCategoryIndexPath?.row)!]
            let products = category.sub_categories[collectionView.tag].five_items
            
            cell.configureCell(product: products![indexPath.row])
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collectionViewMenu {
            
            self.selectedCategoryIndexPath = indexPath
            
            self.tableView.reloadData()
            self.collectionViewSlider.reloadData()
            self.collectionViewMenu.reloadData()
            
            self.constraintTableViewHeight.constant = CGFloat(self.categoriesArray[indexPath.row].sub_categories.count) * cellHeight
            
            if self.categoriesArray.count > 0 {
                let catId = self.categoriesArray[indexPath.row].id
                self.slidersArray = CoreDataManager.shared.getAllSliders(predicate: NSPredicate.init(format: "category_id == %d", catId))
                self.pageController.numberOfPages = slidersArray.count
                self.collectionViewSlider.reloadData()
            }
            
            
        } else if collectionView == collectionViewSlider {
            
             if let product = self.slidersArray[indexPath.row].item {
                performSegue(withIdentifier: AppRouter.toFoodItemDetailViewController, sender: product)
            }
            
        }
            
        else {
            
            let category = self.categoriesArray[(self.selectedCategoryIndexPath?.row)!]
            let products = category.sub_categories[collectionView.tag].five_items
            let product = products?[indexPath.row]
            
            self.subcategoryName = category.sub_categories[collectionView.tag].name!
            
            self.performSegue(withIdentifier: AppRouter.toFoodItemDetailViewController, sender: product)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.collectionViewSlider{
            
            return CGSize.init(width: self.collectionViewSlider.frame.size.width, height: self.collectionViewSlider.frame.size.height)
            
        } else if collectionView == self.collectionViewMenu {
            
            return CGSize.init(width: 150, height: 50)
            
        } else{
            
            //            let height: CGFloat = 230
            //            let width: CGFloat = (height - 31) * (16/9)
            return CGSize.init(width: (244), height: 180)
            
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentIndex = self.collectionViewSlider.contentOffset.x / self.collectionViewSlider.frame.size.width

        if self.sliderIndex < self.slidersArray.count {

            self.sliderIndex = Int(currentIndex)
            self.pageController.currentPage = Int(currentIndex)
            self.sliderIndex = self.sliderIndex < (self.slidersArray.count - 1)  ? sliderIndex + 1 : 0
            //self.startTimer()
        }
        
    }
}

//MARK: - HTTPResponseDelegate
extension HomeViewController: HTTPResponseDelegate {
    
    func httpRequestFinishWithSuccess(response: Any, service: HTTPServices) {
        
        Loader.dismissLoader(viewController: self)
        
        switch service {
        case .guestLogin, .registerDeviceFcm:
            
            self.noDataView.isHidden = true
            self.homeView.isHidden = false
            
        case .getRestaurantData:
            
            self.loadDataFromCoreData()
            
            
        default:
            print("nothing")
        }
    }
    
    func httpRequestFinishWithError(message: String, service: HTTPServices) {
        
        Loader.dismissLoader(viewController: self)
        
        switch service {
            
        case .guestLogin, .getRestaurantData:
            Alert.showAlert(vc: self, title: "Error!", message: message)
        default:
            print("nothing")
        }
    }
    
    
}
