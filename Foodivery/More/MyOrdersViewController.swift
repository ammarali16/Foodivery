//
//  MyOrdersViewController.swift
//  Foodivery
//
//  Created by Admin on 4/22/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import UIKit

class MyOrdersViewController: UIViewController {
    
    var viewModel: MyOrdersViewModel!
    var activeOrderArray = [Orders]()
    var pastOrdersArray = [Orders]()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var sectionsArray = [SectionModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.viewModel = MyOrdersViewModelImp()
        self.viewModel.httpResponseHandler = self
        
        self.addObservers()
        self.loadData()
    }
    
    deinit {
        removeObservers()
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name: NSNotification.Name.reloadOrdres, object: nil)
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: .reloadOrdres, object: nil)
    }
    
    func loadDataFromCoreData(){
        
        self.activeOrderArray = CoreDataManager.shared.getAllOrders(predicate: NSPredicate.init(format: "status == 0 OR status = 1" ))
        self.pastOrdersArray = CoreDataManager.shared.getAllOrders(predicate: NSPredicate.init(format: "status == 2 OR status = 3" ))
        
        print("activeorders:\(activeOrderArray)")
        print("pastorders:\(pastOrdersArray)")
        
        let activeOrdersSection = SectionModel.init(title: "Active Orders", dataArrray: self.activeOrderArray)
        
        let pastOrdersSection = SectionModel.init(title: "Past Orders", dataArrray: self.pastOrdersArray)
        
        
        self.sectionsArray.removeAll()
        self.sectionsArray.append(activeOrdersSection)
        self.sectionsArray.append(pastOrdersSection)
        
        self.tableView.reloadData()
    }
    
    @objc func loadData(){
        
        self.loadDataFromCoreData()
        
        if Connectivity.isConnectedToInternet() {
            if self.activeOrderArray.count == 0 && self.pastOrdersArray.count == 0 {
                Loader.showLoader(viewController: self)
            }
            self.viewModel.getMyOrdersData()
        }else{
            if self.activeOrderArray.count == 0 && self.pastOrdersArray.count == 0 {
                Alert.showNoInternetAlert(vc: self)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destVC = segue.destination as? OrderStatusDetailViewController {
            destVC.orderObject = sender as? Orders
        }
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
    }
    
}

extension MyOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionsArray[section].dataArrray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrdersTableViewCell
        
       let title = sectionsArray[indexPath.section].title
        
       let ordersObject = self.sectionsArray[indexPath.section].dataArrray[indexPath.row]
        cell.configureCell(orderObject: ordersObject)
        return cell

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let label = UILabel()
        label.text = sectionsArray[section].title
        label.backgroundColor = UIColor.lightGray
        return label
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let orderObject = self.sectionsArray[indexPath.section].dataArrray[indexPath.row]
        self.performSegue(withIdentifier: "toOrderStatusDetailViewController", sender: orderObject)
    }
    
    
}


//MARK: - HTTPResponseDelegate
extension MyOrdersViewController: HTTPResponseDelegate {
    
    func httpRequestFinishWithSuccess(response: Any, service: HTTPServices) {
        
        Loader.dismissLoader(viewController: self)
        
        switch service {
            
        case .getMyOrders:
            
            self.loadDataFromCoreData()
            
        default:
            print("nothing")
        }
    }
    
    func httpRequestFinishWithError(message: String, service: HTTPServices) {
        
        Loader.dismissLoader(viewController: self)
        
        switch service {
            
        case .getMyOrders:
            Alert.showAlert(vc: self, title: "Error!", message: message)
        default:
            print("nothing")
        }
    }
    
    
}
