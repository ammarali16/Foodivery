//
//  CoreDataManager.swift
//  Foodivery
//
//  Created by Admin on 2/6/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class CoreDataManager: NSObject {
    
    static let shared = CoreDataManager()
    
    override private init() {}
    
}

//MARK: - CATEGORIES

extension CoreDataManager {
    
    
    //MARK: - Get All categories
    
    public func getAllCateogries(predicate: NSPredicate? = nil) -> [Category] {
        
        var cateogriesArray = [Category]()
        let context = CoreDataPersistenceServices.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.categoryEntityName)
        request.returnsObjectsAsFaults = false
        
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        do {
            
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                
                let id               = data.value(forKey: "id") as! Int
                let restaurant_id    = data.value(forKey: "restaurant_id") as! Int
                let name             = data.value(forKey: "name") as! String
                let description      = data.value(forKey: "desc") as? String
                let imageUrl         = data.value(forKey: "imageUrl") as? String
                let sub_categories   = self.getAllSubcategoriesByCategory(id: id)
                
                let category = Category(id: id, restaurant_id: restaurant_id, name: name, description: description, imageUrl: imageUrl, sub_categories: sub_categories)
                
                cateogriesArray.append(category)
            }
            
            return cateogriesArray
            
        } catch {
            print("get all cateogries Failed")
            return cateogriesArray
        }
    }
    
    
    //MARK: - Get category By Id
    
    public func getCategoryById(categoryId: Int) -> Category? {
        
        var category: Category?
        let context = CoreDataPersistenceServices.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.categoryEntityName)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate.init(format: "id == %d", categoryId)
        
        do {
            
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                
                let id               = data.value(forKey: "id") as! Int
                let restaurant_id    = data.value(forKey: "restaurant_id") as! Int
                let name             = data.value(forKey: "name") as! String
                let description      = data.value(forKey: "desc") as? String
                let imageUrl         = data.value(forKey: "imageUrl") as? String
                let sub_categories   = self.getAllSubcategoriesByCategory(id: id)
                
                category = Category(id: id, restaurant_id: restaurant_id, name: name, description: description, imageUrl: imageUrl, sub_categories: sub_categories)
                
                break
            }
            
            return category
            
        } catch {
            print("getSubcategoriesById Failed")
            return category
        }
    }
    
    //MARK: - Add Category
    
    public func addCategory(category: Category) {
        
        let context = CoreDataPersistenceServices.context
        let entity = NSEntityDescription.entity(forEntityName: Constants.categoryEntityName, in: context)
        
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObject.setValue(category.id, forKey: "id")
        managedObject.setValue(category.restaurant_id, forKey: "restaurant_id")
        managedObject.setValue(category.name, forKey: "name")
        managedObject.setValue(category.description, forKey: "desc")
        managedObject.setValue(category.imageUrl, forKey: "imageUrl")
        
        do {
            try context.save()
        } catch {
            print("Failed saving cateogry")
        }
    }
    
    //MARK: - Update Cateogry
    
    public func updateCategory(cateogry: Category) -> Bool {
        
        let context = CoreDataPersistenceServices.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.categoryEntityName)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate.init(format: "id == %d", cateogry.id)
        
        do {
            
            let result = try context.fetch(request)
            
            if result.count > 0 {
                
                let objectUpdate = result[0] as! NSManagedObject
                
                objectUpdate.setValue(cateogry.id, forKey: "id")
                objectUpdate.setValue(cateogry.restaurant_id, forKey: "restaurant_id")
                objectUpdate.setValue(cateogry.name, forKey: "name")
                objectUpdate.setValue(cateogry.description, forKey: "desc")
                objectUpdate.setValue(cateogry.imageUrl, forKey: "imageUrl")
                
                do{
                    try context.save()
                    return true
                }
                catch {
                    print("cateogry updation error: \(error.localizedDescription)")
                    return false
                }
            }
        } catch {
            print("cateogry not found")
        }
        
        return false
    }
    
    
    //MARK: - Delete All Cateogries
    
    public func deleteAllCateogries(){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.categoryEntityName)
        let context = CoreDataPersistenceServices.context
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            print("All cateogry deleted")
        } catch {
            print("cateogry not found")
        }
        
    }
    
    
    //MARK: - Delete Cateogry By Id
    
    
    public func deleteCateogryById(categoryId: Int){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.categoryEntityName)
        fetchRequest.predicate = NSPredicate.init(format: "id == %d", categoryId)
        
        let context = CoreDataPersistenceServices.context
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            print("category deleted")
        } catch {
            print("category not found")
        }
        
    }
    
}



//MARK: - SUB-CATEGORIES

extension CoreDataManager {
    
    
    //MARK: - Get All Subcateogries
    
    public func getAllSubcateogries(predicate: NSPredicate?) -> [SubCategory] {
        
        var subcateogriesArray = [SubCategory]()
        let context = CoreDataPersistenceServices.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.subCategoryEntityName)
        request.returnsObjectsAsFaults = false
        
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        do {
            
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                
                let id               = data.value(forKey: "id") as! Int
                let category_id      = data.value(forKey: "category_id") as! Int
                let name             = data.value(forKey: "name") as! String
                let description      = data.value(forKey: "desc") as? String
                let imageUrl         = data.value(forKey: "imageUrl") as? String
                let five_items       = self.getAllProductsBySubCategory(id: id)
                
                let subCategory = SubCategory(id: id, category_id: category_id, name: name, description: description, imageUrl: imageUrl, five_items: five_items)
                
                subcateogriesArray.append(subCategory)
            }
            
            return subcateogriesArray
            
        } catch {
            print("getAllSubcateogries Failed")
            return subcateogriesArray
        }
    }
    
    
    
    
    func getAllSubcategoriesByCategory(id: Int) -> [SubCategory] {
        let predicate = NSPredicate.init(format: "category_id == %d", id)
        return self.getAllSubcateogries(predicate: predicate)
    }
    
    //MARK: - Get Subcategory By Id
    
    public func getSubcategoryById(subcategoryId: Int) -> SubCategory? {
        
        var subcategory: SubCategory?
        let context = CoreDataPersistenceServices.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.subCategoryEntityName)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate.init(format: "id == %d", subcategoryId)
        
        do {
            
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                
                let id               = data.value(forKey: "id") as! Int
                let category_id      = data.value(forKey: "category_id") as! Int
                let name             = data.value(forKey: "name") as! String
                let description      = data.value(forKey: "desc") as? String
                let imageUrl         = data.value(forKey: "imageUrl") as? String
                let five_items       = self.getAllProductsBySubCategory(id: id)
                
                subcategory = SubCategory(id: id, category_id: category_id, name: name, description: description, imageUrl: imageUrl, five_items: five_items)
                
                break
            }
            
            return subcategory
            
        } catch {
            print("getSubcategoriesById Failed")
            return subcategory
        }
    }
    
    //MARK: - Add Subcategory
    
    public func addSubcategory(subcategory: SubCategory) {
        
        let context = CoreDataPersistenceServices.context
        let entity = NSEntityDescription.entity(forEntityName: Constants.subCategoryEntityName, in: context)
        
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObject.setValue(subcategory.id, forKey: "id")
        managedObject.setValue(subcategory.category_id, forKey: "category_id")
        managedObject.setValue(subcategory.name, forKey: "name")
        managedObject.setValue(subcategory.description, forKey: "desc")
        managedObject.setValue(subcategory.imageUrl, forKey: "imageUrl")
        
        do {
            try context.save()
        } catch {
            print("Failed saving Subcateogry")
        }
    }
    
    //MARK: - Update subcateogry
    
    public func updateSubcategory(subcateogry: SubCategory) -> Bool {
        
        let context = CoreDataPersistenceServices.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.subCategoryEntityName)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate.init(format: "id == %d", subcateogry.id)
        
        do {
            
            let result = try context.fetch(request)
            
            if result.count > 0 {
                
                let objectUpdate = result[0] as! NSManagedObject
                objectUpdate.setValue(subcateogry.id, forKey: "id")
                objectUpdate.setValue(subcateogry.category_id, forKey: "sub_category_id")
                objectUpdate.setValue(subcateogry.name, forKey: "name")
                objectUpdate.setValue(subcateogry.description, forKey: "desc")
                objectUpdate.setValue(subcateogry.imageUrl, forKey: "imageUrl")
                
                do{
                    try context.save()
                    return true
                }
                catch {
                    print("subcateogry updation error: \(error.localizedDescription)")
                    return false
                }
            }
        } catch {
            print("subcateogry not found")
        }
        
        return false
    }
    
    
    //MARK: - Delete All Subcategories
    
    public func deleteAllSubcateogries(){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.subCategoryEntityName)
        let context = CoreDataPersistenceServices.context
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            print("All subcateogry deleted")
        } catch {
            print("subcateogry not found")
        }
        
    }
    
    
    //MARK: - Delete Subcategory By Id
    
    
    public func deleteSubcateogryById(subcategoryId: Int){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.productEntityName)
        fetchRequest.predicate = NSPredicate.init(format: "id == %d", subcategoryId)
        
        let context = CoreDataPersistenceServices.context
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            print("subcategory deleted")
        } catch {
            print("subcategory not found")
        }
        
    }
    
}


//MARK: - SLIDERS

extension CoreDataManager{
    
    //MARK: - Get All Sliders
    
    public func getAllSliders(predicate: NSPredicate?) -> [Sliders] {

        var slidersArray = [Sliders]()
        let context = CoreDataPersistenceServices.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.slidersEntityName)
        request.returnsObjectsAsFaults = false

        if let predicate = predicate {
            request.predicate = predicate
        }

        do {

            let result = try context.fetch(request)

            for data in result as! [NSManagedObject] {

                let id               = data.value(forKey: "id") as! Int
                let name             = data.value(forKey: "name") as! String
                let description      = data.value(forKey: "desc") as? String
                let category_id      = data.value(forKey: "category_id") as! Int
                let deal_id          = data.value(forKey: "deal_id") as? Int
                let sub_category_id  = data.value(forKey: "sub_category_id") as! Int
                let item_id          = data.value(forKey: "item_id") as! Int
                let sub_categories   = self.getSubcategoryById(subcategoryId: sub_category_id)
                let item             = self.getProductById(productId: item_id)
                let media            = self.getAllMediaByModelId(id: id)
                
               
                

                let slider = Sliders.init(id: id, name: name, description: description, category_id: category_id, deal_id: deal_id, sub_category_id: sub_category_id, item_id: item_id, media: media, sub_category: sub_categories , item: item)

                slidersArray.append(slider)
            }

            return slidersArray

        } catch {
            print("getAllSubcateogries Failed")
            return slidersArray
        }
    }
    
    
    //MARK: - Add Sliders
    
    public func addSliders(sliders: Sliders) {
        
        let context = CoreDataPersistenceServices.context
        let entity = NSEntityDescription.entity(forEntityName: Constants.slidersEntityName, in: context)
        
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObject.setValue(sliders.id, forKey: "id")
        managedObject.setValue(sliders.name, forKey: "name")
        managedObject.setValue(sliders.description, forKey: "desc")
        managedObject.setValue(sliders.category_id, forKey: "category_id")
        managedObject.setValue(sliders.deal_id, forKey: "deal_id")
        managedObject.setValue(sliders.sub_category_id, forKey: "sub_category_id")
        managedObject.setValue(sliders.item_id, forKey: "item_id")
    
        
        do {
            try context.save()
        } catch {
            print("Failed saving Slides")
        }
    }
    
    
    //MARK: - Delete All Sliders
    
    public func deleteAllSliders(){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.slidersEntityName)
        let context = CoreDataPersistenceServices.context
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            print("All Sliders deleted")
        } catch {
            print("Sliders not found")
        }
        
    }
    
}



//MARK: - SLIDERS IMAGES

extension CoreDataManager{
    
//    MARK: - Get All Slider Images

    public func getAllMediaImages(predicate: NSPredicate?) -> [SlidesImage] {

        var mediaArray = [SlidesImage]()
        let context = CoreDataPersistenceServices.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.slidersImageEntityName)
        request.returnsObjectsAsFaults = false

        if let predicate = predicate {
            request.predicate = predicate
        }

        do {

            let result = try context.fetch(request)

            for data in result as! [NSManagedObject] {

                let id               = data.value(forKey: "id") as! Int
                let model_id         = data.value(forKey: "model_id") as! Int
                let name             = data.value(forKey: "name") as? String
                let url              = data.value(forKey: "url") as? String
                let collection_name  = data.value(forKey: "collection_name") as? String
                let mime_type        = data.value(forKey: "mime_type") as? String
             
                let media = SlidesImage.init(id: id, model_id: model_id, collection_name: collection_name, mime_type: mime_type, name: name, url: url)

                mediaArray.append(media)
                
            }

            return mediaArray

        } catch {
            print("getAllProducts Failed")
            return mediaArray
        }
    }
    
    func getAllMediaByModelId(id: Int) -> [SlidesImage] {
        let predicate = NSPredicate.init(format: "model_id == %d", id)
        return self.getAllMediaImages(predicate: predicate)
    }
    
//    //MARK: - Add Sliders Image
    
    
    public func addSlidersImage(slidersImage: SlidesImage) {

        let context = CoreDataPersistenceServices.context
        let entity = NSEntityDescription.entity(forEntityName: Constants.slidersImageEntityName, in: context)

        let managedObject = NSManagedObject(entity: entity!, insertInto: context)

        managedObject.setValue(slidersImage.id, forKey: "id")
        managedObject.setValue(slidersImage.model_id, forKey: "model_id")
        managedObject.setValue(slidersImage.name, forKey: "name")
        managedObject.setValue(slidersImage.collection_name, forKey: "collection_name")
        managedObject.setValue(slidersImage.mime_type, forKey: "mime_type")
        managedObject.setValue(slidersImage.url, forKey: "url")


        do {
            try context.save()
            print("SliderImageSaved")
        } catch {
            print("Failed saving Sliders Image")
        }
    }
   
    
   
    
    //MARK: - Delete All Sliders Images
    
    public func deleteAllSlidersImage(){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.slidersImageEntityName)
        let context = CoreDataPersistenceServices.context
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            print("All Sliders Image deleted")
        } catch {
            print("Sliders Image not found")
        }
        
    }
    
}


//MARK: - PRODUCT

extension CoreDataManager{
    
    //MARK: - Get All Products
    
    public func getAllProducts(predicate: NSPredicate?) -> [Product] {
        
        var productsArray = [Product]()
        let context = CoreDataPersistenceServices.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.productEntityName)
        request.returnsObjectsAsFaults = false
        
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        do {
            
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                
                let id               = data.value(forKey: "id") as! Int
                let sub_category_id  = data.value(forKey: "sub_category_id") as! Int
                let name             = data.value(forKey: "name") as! String
                let description      = data.value(forKey: "desc") as? String
                let imageUrl         = data.value(forKey: "imageUrl") as? String
                let price            = data.value(forKey: "price") as! Int
                
                let product = Product(id: id, sub_category_id: sub_category_id, name: name, description: description, imageUrl: imageUrl, price: price)
                
                productsArray.append(product)
            }
            
            return productsArray
            
        } catch {
            print("getAllProducts Failed")
            return productsArray
        }
    }
    
    func getAllProductsBySubCategory(id: Int) -> [Product] {
        let predicate = NSPredicate.init(format: "sub_category_id == %d", id)
        return self.getAllProducts(predicate: predicate)
    }
    
    //MARK: - Get Product By Id
    
    public func getProductById(productId: Int) -> Product? {
        
        var product: Product?
        let context = CoreDataPersistenceServices.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.productEntityName)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate.init(format: "id == %d", productId)
        
        do {
            
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                
                let id               = data.value(forKey: "id") as! Int
                let sub_category_id  = data.value(forKey: "sub_category_id") as! Int
                let name             = data.value(forKey: "name") as! String
                let description      = data.value(forKey: "desc") as? String
                let imageUrl         = data.value(forKey: "imageUrl") as? String
                let price            = data.value(forKey: "price") as! Int
                
                product = Product(id: id, sub_category_id: sub_category_id, name: name, description: description, imageUrl: imageUrl, price: price)
                
                break
            }
            
            return product
            
        } catch {
            print("getProductById Failed")
            return product
        }
    }
    
    //MARK: - Add Product
    
    public func addProduct(product: Product) {
        
        let context = CoreDataPersistenceServices.context
        let entity = NSEntityDescription.entity(forEntityName: Constants.productEntityName, in: context)
        
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObject.setValue(product.id, forKey: "id")
        managedObject.setValue(product.sub_category_id, forKey: "sub_category_id")
        managedObject.setValue(product.name, forKey: "name")
        managedObject.setValue(product.description, forKey: "desc")
        managedObject.setValue(product.imageUrl, forKey: "imageUrl")
        managedObject.setValue(product.price, forKey: "price")
        
        do {
            try context.save()
        } catch {
            print("Failed saving product")
        }
    }
    
    //MARK: - Update Product
    
    public func updateProduct(product: Product) -> Bool {
        
        let context = CoreDataPersistenceServices.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.productEntityName)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate.init(format: "id == %d", product.id)
        
        do {
            
            let result = try context.fetch(request)
            
            if result.count > 0 {
                
                let objectUpdate = result[0] as! NSManagedObject
                objectUpdate.setValue(product.id, forKey: "id")
                objectUpdate.setValue(product.sub_category_id, forKey: "sub_category_id")
                objectUpdate.setValue(product.name, forKey: "name")
                objectUpdate.setValue(product.description, forKey: "desc")
                objectUpdate.setValue(product.imageUrl, forKey: "imageUrl")
                objectUpdate.setValue(product.price, forKey: "price")
                
                do{
                    try context.save()
                    return true
                }
                catch {
                    print("Product updation error: \(error.localizedDescription)")
                    return false
                }
            }
        } catch {
            print("Product not found")
        }
        
        return false
    }
    
    
    //MARK: - Delete All Products
    
    public func deleteAllProducts(){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.productEntityName)
        let context = CoreDataPersistenceServices.context
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            print("All product deleted")
        } catch {
            print("Product not found")
        }
        
    }
    
    
    //MARK: - Delete All Products By SubcategoryId
    
    public func deleteAllProductsBySubcategory(subcategoryId: Int){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.productEntityName)
        fetchRequest.predicate = NSPredicate.init(format: "sub_category_id == \(subcategoryId)")
        let context = CoreDataPersistenceServices.context
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            print("All Products deleted")
        } catch {
            print("Products not found")
        }
        
    }
    
    //MARK: - Delete Product By Id
    
    
    public func deleteProductById(productId: Int){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.productEntityName)
        fetchRequest.predicate = NSPredicate.init(format: "id == %d", productId)
        
        let context = CoreDataPersistenceServices.context
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            print("product deleted")
        } catch {
            print("product not found")
        }
        
    }
    
    
}


//MARK: - DEALS

extension CoreDataManager{
    
    //MARK: - Get All Deals
    
    public func getAllDeals(predicate: NSPredicate?) -> [Deals] {
        
        var dealsArray = [Deals]()
        let context = CoreDataPersistenceServices.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.dealsEntityName)
        request.returnsObjectsAsFaults = false
        
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        do {
            
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                
                let id               = data.value(forKey: "id") as! Int
                let restaurant_id  = data.value(forKey: "restaurant_id") as! Int
                let name             = data.value(forKey: "name") as! String
                let description      = data.value(forKey: "desc") as? String
                let imageUrl         = data.value(forKey: "imageUrl") as? String
                let price            = data.value(forKey: "price") as! Int
                
                let deal = Deals.init(id: id, restaurant_id: restaurant_id, name: name, description: description, imageUrl: imageUrl, price: price)
                
                dealsArray.append(deal)
            }
            
            return dealsArray
            
        } catch {
            print("getAllDeals Failed")
            return dealsArray
        }
    }
    
    //MARK: - Get Deals By Id
    
    public func getDealsById(dealId: Int) -> Deals? {
        
        var deal: Deals?
        let context = CoreDataPersistenceServices.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.dealsEntityName)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate.init(format: "id == %d", dealId)
        
        do {
            
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                
                let id               = data.value(forKey: "id") as! Int
                let restaurant_id    = data.value(forKey: "restaurant_id") as! Int
                let name             = data.value(forKey: "name") as! String
                let description      = data.value(forKey: "desc") as? String
                let imageUrl         = data.value(forKey: "imageUrl") as? String
                let price            = data.value(forKey: "price") as! Int
                
                deal = Deals.init(id: id, restaurant_id: restaurant_id, name: name, description: description, imageUrl: imageUrl, price: price)
                
                break
            }
            
            return deal
            
        } catch {
            print("getSubcategoriesById Failed")
            return deal
        }
    }
    
    //MARK: - Add Deals
    
    public func addDeals(deal: Deals) {
        
        let context = CoreDataPersistenceServices.context
        let entity = NSEntityDescription.entity(forEntityName: Constants.dealsEntityName, in: context)
        
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObject.setValue(deal.id, forKey: "id")
        managedObject.setValue(deal.restaurant_id, forKey: "restaurant_id")
        managedObject.setValue(deal.name, forKey: "name")
        managedObject.setValue(deal.description, forKey: "desc")
        managedObject.setValue(deal.imageUrl, forKey: "imageUrl")
        managedObject.setValue(deal.price, forKey: "price")
        
        do {
            try context.save()
        } catch {
            print("Failed saving Deals")
        }
    }
    
    
    //MARK: - Update deal
    
    public func updateDeal(deal: Deals) -> Bool {
        
        let context = CoreDataPersistenceServices.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.dealsEntityName)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate.init(format: "id == %d", deal.id)
        
        do {
            
            let result = try context.fetch(request)
            
            if result.count > 0 {
                
                let objectUpdate = result[0] as! NSManagedObject
                
                objectUpdate.setValue(deal.id, forKey: "id")
                objectUpdate.setValue(deal.restaurant_id, forKey: "restaurant_id")
                objectUpdate.setValue(deal.name, forKey: "name")
                objectUpdate.setValue(deal.description, forKey: "desc")
                objectUpdate.setValue(deal.imageUrl, forKey: "imageUrl")
                objectUpdate.setValue(deal.price, forKey: "price")
                
                do{
                    try context.save()
                    return true
                }
                catch {
                    print("deal updation error: \(error.localizedDescription)")
                    return false
                }
            }
        } catch {
            print("deal not found")
        }
        
        return false
    }
    
    //MARK: - Delete All Deals
    
    public func deleteAllDeals(){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.dealsEntityName)
        let context = CoreDataPersistenceServices.context
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            print("All deals deleted")
        } catch {
            print("deals not found")
        }
        
    }
    
    
    //MARK: - Delete Deal By Id
    
    
    public func deleteDealById(dealId: Int){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.dealsEntityName)
        fetchRequest.predicate = NSPredicate.init(format: "id == %d", dealId)
        
        let context = CoreDataPersistenceServices.context
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            print("deal deleted")
        } catch {
            print("deal not found")
        }
        
    }
    
}


//MARK: - MY ORDERS

extension CoreDataManager {
    
    
    //MARK: - Get All Orders
    
    public func getAllOrders(predicate: NSPredicate? = nil) -> [Orders] {
        
        var ordersArray = [Orders]()
        let context = CoreDataPersistenceServices.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.ordersEntityName)
        request.returnsObjectsAsFaults = false
        
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        
        //request.predicate = NSPredicate.init(format: "status == %d")
        
        do {
            
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                
                let id               = data.value(forKey: "id") as! Int
                let user_id          = data.value(forKey: "user_id") as? Int
                let restaurant_id    = data.value(forKey: "restaurant_id") as? Int
                let user_address_id  = data.value(forKey: "user_address_id") as? Int
                let delivery_time    = data.value(forKey: "delivery_time") as? String
                let status           = data.value(forKey: "status") as? Int
                let status_message   = data.value(forKey: "status_message") as? String
                let created_at       = data.value(forKey: "created_at") as? String
                let updated_at       = data.value(forKey: "updated_at") as? String
                let tax              = data.value(forKey: "tax") as? String
                let delivery_charges = data.value(forKey: "delivery_charges") as? String
                let sub_total        = data.value(forKey: "sub_total") as? String
                let total            = data.value(forKey: "total") as? String
                let order_item       = self.getAllOrderItemsByOrder(id: id)
                let address          = self.getAddressById(addressId: user_address_id!)
                
                let order = Orders.init(id: id, user_id: user_id, restaurant_id: restaurant_id, user_address_id: user_address_id, delivery_time: delivery_time, status: status, status_message: status_message, created_at: created_at, updated_at: updated_at, tax: tax, delivery_charges: delivery_charges, sub_total: sub_total, total: total, order_items: order_item, address: address)
                
//                let order = Orders.init(id: id, user_id: user_id, restaurant_id: restaurant_id, user_address_id: user_address_id, delivery_time: delivery_time, status: status, status_message: status_message, created_at: created_at, updated_at: updated_at, tax: tax, delivery_charges: delivery_charges, sub_total: sub_total, total: total)
                
                ordersArray.append(order)
            }
            
            return ordersArray
            
        } catch {
            print("get all cateogries Failed")
            return ordersArray
        }
    }
    
    
    
    //MARK: - Add Orders

    public func addOrders(order: Orders) {

        let context = CoreDataPersistenceServices.context
        let entity = NSEntityDescription.entity(forEntityName: Constants.ordersEntityName, in: context)

        let managedObject = NSManagedObject(entity: entity!, insertInto: context)

        managedObject.setValue(order.id, forKey: "id")
        managedObject.setValue(order.user_id, forKey: "user_id")
        managedObject.setValue(order.restaurant_id, forKey: "restaurant_id")
        managedObject.setValue(order.user_address_id, forKey: "user_address_id")
        managedObject.setValue(order.delivery_time, forKey: "delivery_time")
        managedObject.setValue(order.status, forKey: "status")
        managedObject.setValue(order.status_message, forKey: "status_message")
        managedObject.setValue(order.created_at, forKey: "created_at")
        managedObject.setValue(order.updated_at, forKey: "updated_at")
        managedObject.setValue(order.tax, forKey: "tax")
        managedObject.setValue(order.delivery_charges, forKey: "delivery_charges")
        managedObject.setValue(order.sub_total, forKey: "sub_total")
        managedObject.setValue(order.total, forKey: "total")

        do {
            try context.save()
        } catch {
            print("Failed saving orders")
        }
    }
    
    

    
//    
//    //MARK: - Get category By Id
//    
//    public func getOrderById(orderId: Int) -> Orders? {
//        
//        var category: Orders?
//        let context = CoreDataPersistenceServices.context
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.ordersEntityName)
//        request.returnsObjectsAsFaults = false
//        request.predicate = NSPredicate.init(format: "id == %d", orderId)
//        
//        do {
//            
//            let result = try context.fetch(request)
//            
//            for data in result as! [NSManagedObject] {
//                
//                let id               = data.value(forKey: "id") as! Int
//                let restaurant_id    = data.value(forKey: "restaurant_id") as! Int
//                let name             = data.value(forKey: "name") as! String
//                let description      = data.value(forKey: "desc") as? String
//                let imageUrl         = data.value(forKey: "imageUrl") as? String
//                let sub_categories   = self.getAllSubcategoriesByCategory(id: id)
//                
//                category = Category(id: id, restaurant_id: restaurant_id, name: name, description: description, imageUrl: imageUrl, sub_categories: sub_categories)
//                
//                break
//            }
//            
//            return category
//            
//        } catch {
//            print("getSubcategoriesById Failed")
//            return category
//        }
//    }
    
   
    //MARK: - Update Order
    
    public func updateOrder(order: Orders) -> Bool {
        
        let context = CoreDataPersistenceServices.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.ordersEntityName)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate.init(format: "id == %d", order.id)
        
        do {
            
            let result = try context.fetch(request)
            
            if result.count > 0 {
                
                let objectUpdate = result[0] as! NSManagedObject
                
                objectUpdate.setValue(order.id, forKey: "id")
                objectUpdate.setValue(order.user_id, forKey: "user_id")
                objectUpdate.setValue(order.restaurant_id, forKey: "restaurant_id")
                objectUpdate.setValue(order.user_address_id, forKey: "user_address_id")
                objectUpdate.setValue(order.delivery_time, forKey: "delivery_time")
                objectUpdate.setValue(order.status, forKey: "status")
                objectUpdate.setValue(order.status_message, forKey: "status_message")
                objectUpdate.setValue(order.created_at, forKey: "created_at")
                objectUpdate.setValue(order.updated_at, forKey: "updated_at")
                objectUpdate.setValue(order.tax, forKey: "tax")
                objectUpdate.setValue(order.delivery_charges, forKey: "delivery_charges")
                objectUpdate.setValue(order.sub_total, forKey: "sub_total")
                objectUpdate.setValue(order.total, forKey: "total")
                
                do{
                    try context.save()
                    return true
                }
                catch {
                    print("cateogry updation error: \(error.localizedDescription)")
                    return false
                }
            }
        } catch {
            print("cateogry not found")
        }
        
        return false
    }
    
    
    //MARK: - Delete All Orders
    
    public func deleteAllOrders(){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.ordersEntityName)
        let context = CoreDataPersistenceServices.context
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            print("All orders deleted")
        } catch {
            print("Orders not found")
        }
        
    }
    
    //MARK: - Delete All Orders Items
    
    public func deleteAllOrdersItems(){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.orderItemsEntityName)
        let context = CoreDataPersistenceServices.context
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            print("All orders deleted")
        } catch {
            print("Orders not found")
        }
        
    }
    
    
    //MARK: - Delete Orders By Id
    
    
    public func deleteOrderById(orderId: Int){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.categoryEntityName)
        fetchRequest.predicate = NSPredicate.init(format: "id == %d", orderId)
        
        let context = CoreDataPersistenceServices.context
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            print("order deleted")
        } catch {
            print("order not found")
        }
        
    }
    
}



//MARK: - ORDER ITEMS

extension CoreDataManager {
    
    
    //MARK: - Get All OrderItems
    
    public func getAllOrderItems(predicate: NSPredicate?) -> [OrderItems] {
        
        var orderItemsArray = [OrderItems]()
        let context = CoreDataPersistenceServices.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.orderItemsEntityName)
        request.returnsObjectsAsFaults = false
        
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        do {
            
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                
                let id            = data.value(forKey: "id") as! Int
                let order_id      = data.value(forKey: "order_id") as? Int
                let quantity      = data.value(forKey: "quantity") as? Int
                let created_at    = data.value(forKey: "created_at") as? String
                let item_id       = data.value(forKey: "item_id") as? Int
                let deal_id       = data.value(forKey: "deal_id") as? Int
                let snapshot      = data.value(forKey: "snapshot") as? String
                
                
                let orderItems = OrderItems.init(id: id, order_id: order_id, quantity: quantity, created_at: created_at, item_id: item_id, deal_id: deal_id, snapshot: snapshot)
                
                orderItemsArray.append(orderItems)
            }
            
            return orderItemsArray
            
        } catch {
            print("getAllOrderItems Failed")
            return orderItemsArray
        }
    }
    
    func getAllOrderItemsByOrder(id: Int) -> [OrderItems] {
        let predicate = NSPredicate.init(format: "order_id == %d", id)
        return self.getAllOrderItems(predicate: predicate)
    }
    
    //MARK: - Add Subcategory
    
    public func addOrderItems(orderItems: OrderItems) {
        
        let context = CoreDataPersistenceServices.context
        let entity = NSEntityDescription.entity(forEntityName: Constants.orderItemsEntityName, in: context)
        
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObject.setValue(orderItems.id, forKey: "id")
        managedObject.setValue(orderItems.order_id, forKey: "order_id")
        managedObject.setValue(orderItems.quantity, forKey: "quantity")
        managedObject.setValue(orderItems.created_at, forKey: "created_at")
        managedObject.setValue(orderItems.item_id, forKey: "item_id")
        managedObject.setValue(orderItems.deal_id, forKey: "deal_id")
        managedObject.setValue(orderItems.snapshot, forKey: "snapshot")
        
        
        do {
            try context.save()
        } catch {
            print("Failed saving OrderItems")
        }
    }
    
    
}


//MARK: - FAVORITE

extension CoreDataManager{
    
    //MARK: - Get All Favorite
    
    public func getAllFavorites(predicate: NSPredicate?) -> [Favorite] {
        
        var favoriteArray = [Favorite]()
        let context = CoreDataPersistenceServices.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.favoriteEntityName)
        request.returnsObjectsAsFaults = false
        
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        do {
            
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                
                let id               = data.value(forKey: "id") as! Int
                let itemId             = data.value(forKey: "itemId") as! Int
                let isProduct             = data.value(forKey: "isProduct") as! Bool
                
                
                let favorite = Favorite.init(id: id, itemId: itemId, isProduct: isProduct)
                
                favoriteArray.append(favorite)
            }
            
            return favoriteArray
            
        } catch {
            print("getAllFavortes Failed")
            return favoriteArray
        }
    }
    
    //MARK: - Get Favorite By Id
    
    public func getFavoriteById(favoriteId: Int) -> Favorite? {
        
        var favorite: Favorite?
        let context = CoreDataPersistenceServices.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.favoriteEntityName)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate.init(format: "id == %d", favoriteId)
        
        do {
            
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                
                let id               = data.value(forKey: "id") as! Int
                let itemId             = data.value(forKey: "itemId") as! Int
                let isProduct             = data.value(forKey: "isProduct") as! Bool
                
                
                favorite = Favorite.init(id: id, itemId: itemId, isProduct: isProduct)
                
                
                break
            }
            
            return favorite
            
        } catch {
            print("getFavortieById Failed")
            return favorite
        }
    }
    
    //MARK: - Add Favorite
    
    public func addFavorite(favorite: Favorite) {
        
        let context = CoreDataPersistenceServices.context
        let entity = NSEntityDescription.entity(forEntityName: Constants.favoriteEntityName, in: context)
        
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObject.setValue(favorite.id, forKey: "id")
        managedObject.setValue(favorite.itemId, forKey: "itemId")
        managedObject.setValue(favorite.isProduct, forKey: "isProduct")
        
        do {
            try context.save()
        } catch {
            print("Failed saving Favorites")
        }
    }
    
    //MARK: - Delete Favorite By Id
    
    
    public func deleteFavorite(itemId: Int, isProduct: Bool){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.favoriteEntityName)
        fetchRequest.predicate = NSPredicate.init(format: "itemId == \(itemId) && isProduct == %@", NSNumber.init(value: isProduct))
        
        let context = CoreDataPersistenceServices.context
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            print("favorite deleted")
        } catch {
            print("favorite not found")
        }
        
    }
    
    //Mark: Check already favorit
    public func checkAlreadyFavorite(itemId: Int, isProduct: Bool) -> Bool {
        
        let context = CoreDataPersistenceServices.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.favoriteEntityName)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate.init(format: "itemId == \(itemId) && isProduct == %@", NSNumber.init(value: isProduct))
        
        do {
            
            let result = try context.fetch(request)
            
            return result.count > 0
            
        } catch {
            print("getFavortieById Failed")
            return false
        }
    }
    
    //MARK: - Get Favorite Products
    func getFavoriteProducts() -> [Product] {
        
        var products = [Product]()
        
        let predicate = NSPredicate.init(format: "isProduct == %@", NSNumber.init(value: true))
        let favorites = self.getAllFavorites(predicate: predicate)
        
        for fav in favorites {
            if let product = self.getProductById(productId: fav.itemId) {
                products.append(product)
            }
        }
        
        return products
    }
    
    
    //MARK: - Get Favorite Deals
    func getFavoriteDeals() -> [Deals] {
        
        var deals = [Deals]()
        
        let predicate = NSPredicate.init(format: "isProduct == %@", NSNumber.init(value: false))
        let favorites = self.getAllFavorites(predicate: predicate)
        
        for fav in favorites {
            if let deal = self.getDealsById(dealId: fav.itemId) {
                deals.append(deal)
            }
        }
        
        return deals
    }
    
}


//MARK: - CART

extension CoreDataManager{
    
    //MARK: - Get All CART Items
    
    public func getAllCartItems(predicate: NSPredicate?) -> [Cart] {
        
        var cartArray = [Cart]()
        let context = CoreDataPersistenceServices.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.cartEntityName)
        request.returnsObjectsAsFaults = false
        
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        do {
            
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                
                let id               = data.value(forKey: "id") as! Int
                let itemId             = data.value(forKey: "itemId") as! Int
                let isProduct             = data.value(forKey: "isProduct") as! Bool
                let quantity             = data.value(forKey: "quantity") as! Int
                
                var product: Product? = nil
                var deal: Deals? = nil
                
                if isProduct {
                    product = self.getProductById(productId: itemId)
                }else{
                    deal = self.getDealsById(dealId: itemId)
                }
                
                let cart = Cart.init(id: id, itemId: itemId, isProduct: isProduct, quantity: quantity, product: product, deal: deal)
                
                cartArray.append(cart)
            }
            
            return cartArray
            
        } catch {
            print("getAllCart Failed")
            return cartArray
        }
    }
    
    //MARK: - Get Cart By Id
    
    public func getCartById(cartId: Int) -> Cart? {
        
        var cart: Cart?
        let context = CoreDataPersistenceServices.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.cartEntityName)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate.init(format: "id == %d", cartId)
        
        do {
            
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                
                let id               = data.value(forKey: "id") as! Int
                let itemId           = data.value(forKey: "itemId") as! Int
                let isProduct        = data.value(forKey: "isProduct") as! Bool
                let quantity         = data.value(forKey: "quantity") as! Int
                
                
                var product: Product? = nil
                var deal: Deals? = nil
                
                if isProduct {
                    product = self.getProductById(productId: itemId)
                }else{
                    deal = self.getDealsById(dealId: itemId)
                }
                
                
                cart = Cart.init(id: id, itemId: itemId, isProduct: isProduct, quantity: quantity, product: product, deal: deal)
                
                
                break
            }
            
            return cart
            
        } catch {
            print("getCartById Failed")
            return cart
        }
    }
    //MARK: - Get Cart By Item Id
    
    public func getCartByItemId(itemId: Int, isProduct: Bool) -> Cart? {
        
        var cart: Cart?
        let context = CoreDataPersistenceServices.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.cartEntityName)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate.init(format: "itemId == \(itemId) AND isProduct == %@", NSNumber.init(value: isProduct))
        
        
        do {
            
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                
                let id               = data.value(forKey: "id") as! Int
                let itemId             = data.value(forKey: "itemId") as! Int
                let isProduct             = data.value(forKey: "isProduct") as! Bool
                let quantity             = data.value(forKey: "quantity") as! Int
                
                
                var product: Product? = nil
                var deal: Deals? = nil
                
                if isProduct {
                    product = self.getProductById(productId: itemId)
                }else{
                    deal = self.getDealsById(dealId: itemId)
                }
                
                
                cart = Cart.init(id: id, itemId: itemId, isProduct: isProduct, quantity: quantity, product: product, deal: deal)
                
                
                break
            }
            
            return cart
            
        } catch {
            print("getCartByItemId Failed")
            return cart
        }
    }
    
    
    //MARK: - Update Cart
    
    public func updateCart(cart: Cart) -> Bool {
        
        let context = CoreDataPersistenceServices.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.cartEntityName)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate.init(format: "id == %d", cart.id)
        
        do {
            
            let result = try context.fetch(request)
            
            if result.count > 0 {
                
                let objectUpdate = result[0] as! NSManagedObject
                
                objectUpdate.setValue(cart.id, forKey: "id")
                objectUpdate.setValue(cart.itemId, forKey: "itemId")
                objectUpdate.setValue(cart.isProduct, forKey: "isProduct")
                objectUpdate.setValue(cart.quantity, forKey: "quantity")
                
                
                do{
                    try context.save()
                    return true
                }
                catch {
                    print("address updation error: \(error.localizedDescription)")
                    return false
                }
            }
        } catch {
            print("address not found")
        }
        
        return false
    }
    
    //MARK: - Add To Cart
    
    public func addToCart(cart: Cart) {
        
        let context = CoreDataPersistenceServices.context
        let entity = NSEntityDescription.entity(forEntityName: Constants.cartEntityName, in: context)
        
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObject.setValue(cart.id, forKey: "id")
        managedObject.setValue(cart.itemId, forKey: "itemId")
        managedObject.setValue(cart.isProduct, forKey: "isProduct")
        managedObject.setValue(cart.quantity, forKey: "quantity")
        
        do {
            try context.save()
        } catch {
            print("Failed saving to Cart")
        }
    }
    
    //MARK: - Delete Cart By Id
    
    
    public func deleteCart(itemId: Int, isProduct: Bool){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.cartEntityName)
        fetchRequest.predicate = NSPredicate.init(format: "itemId == \(itemId) && isProduct == %@", NSNumber.init(value: isProduct))
        
        let context = CoreDataPersistenceServices.context
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            print("cart deleted")
        } catch {
            print("cart not found")
        }
        
    }
    
    public func deleteAllCart(){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.cartEntityName)
        let context = CoreDataPersistenceServices.context
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            print("All Cart deleted")
        } catch {
            print("Cart not found")
        }
        
    }
    
    //    //Mark: Check already favorit
    //    public func checkAlreadyFavorite(itemId: Int, isProduct: Bool) -> Bool {
    //
    //        let context = CoreDataPersistenceServices.context
    //        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.favoriteEntityName)
    //        request.returnsObjectsAsFaults = false
    //        request.predicate = NSPredicate.init(format: "itemId == \(itemId) && isProduct == %@", NSNumber.init(value: isProduct))
    //
    //        do {
    //
    //            let result = try context.fetch(request)
    //
    //            return result.count > 0
    //
    //        } catch {
    //            print("getFavortieById Failed")
    //            return false
    //        }
    //    }
    
    //MARK: - Get Cart Products
    func getCartProducts() -> [Product] {
        
        var products = [Product]()
        
        let predicate = NSPredicate.init(format: "isProduct == %@", NSNumber.init(value: true))
        let carts = self.getAllCartItems(predicate: predicate)
        
        for cart in carts {
            if let product = self.getProductById(productId: cart.itemId) {
                products.append(product)
            }
        }
        
        return products
    }
    
    
    //MARK: - Get Favorite Deals
    func getCartDeals() -> [Deals] {
        
        var dealsArray = [Deals]()
        
        let predicate = NSPredicate.init(format: "isProduct == %@", NSNumber.init(value: false))
        let deals = self.getAllCartItems(predicate: predicate)
        
        for deal in deals {
            if let deal = self.getDealsById(dealId: deal.itemId) {
                dealsArray.append(deal)
            }
        }
        
        return dealsArray
    }
    
}

//MARK: - QUANTITY

extension CoreDataManager{
    
    //MARK: - Update Quantity
    
    public func updateCartQuantity(cartId: Int, quantity: Int) -> Bool {
        
        let context = CoreDataPersistenceServices.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.cartEntityName)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate.init(format: "id == %d", cartId)
        
        do {
            
            let result = try context.fetch(request)
            
            if result.count > 0 {
                
                let objectUpdate = result[0] as! NSManagedObject
                
                objectUpdate.setValue(quantity, forKey: "quantity")
                
                
                do{
                    try context.save()
                    return true
                }
                catch {
                    print("deal updation error: \(error.localizedDescription)")
                    return false
                }
            }
        } catch {
            print("deal not found")
        }
        
        return false
    }
}

extension CoreDataManager{
    
    //MARK: - Get All Address
    
    public func getAllAddress(predicate: NSPredicate?) -> [Address] {
        
        var addressArray = [Address]()
        let context = CoreDataPersistenceServices.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.addressEntityName)
        request.returnsObjectsAsFaults = false
        
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        do {
            
            
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                
                let id               = data.value(forKey: "id") as! Int
                let title            = data.value(forKey: "title") as? String
                let address          = data.value(forKey: "address") as? String
                let street           = data.value(forKey: "street") as? String
                let area             = data.value(forKey: "area") as? String
                let floor            = data.value(forKey: "floor") as? String
                
                let addresss = Address.init(id: id, title: title, address: address, street: street, area: area, floor: floor)
                
                addressArray.append(addresss)
            }
            
            return addressArray
            
        } catch {
            print("getAllAddress Failed")
            return addressArray
        }
    }
    
    //MARK: - Get Address By Id
    
    public func getAddressById(addressId: Int) -> Address? {
        
        var adress: Address?
        let context = CoreDataPersistenceServices.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.addressEntityName)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate.init(format: "id == %d", addressId)
        
        do {
            
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                
                let id               = data.value(forKey: "id") as! Int
                let title            = data.value(forKey: "title") as? String
                let address          = data.value(forKey: "address") as? String
                let street           = data.value(forKey: "street") as? String
                let area             = data.value(forKey: "area") as? String
                let floor            = data.value(forKey: "floor") as? String
                
                adress = Address.init(id: id, title: title, address: address, street: street, area: area, floor: floor)
                
                break
            }
            
            return adress
            
        } catch {
            print("getAddressById Failed")
            return adress
        }
    }
    
    //MARK: - Add Deals
    
    public func addAddress(address: Address) {
        
        print(address)
        let context = CoreDataPersistenceServices.context
        let entity = NSEntityDescription.entity(forEntityName: Constants.addressEntityName, in: context)
        
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObject.setValue(address.id, forKey: "id")
        managedObject.setValue(address.title, forKey: "title")
        managedObject.setValue(address.address, forKey: "address")
        managedObject.setValue(address.street, forKey: "street")
        managedObject.setValue(address.area, forKey: "area")
        managedObject.setValue(address.floor, forKey: "floor")
        
        do {
            try context.save()
        } catch {
            print("Failed saving Address")
        }
    }
    
    
    //MARK: - Update Address
    
    public func updateAddress(address: Address) -> Bool {
        
        let context = CoreDataPersistenceServices.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.addressEntityName)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate.init(format: "id == %d", address.id)
        
        do {
            
            let result = try context.fetch(request)
            
            if result.count > 0 {
                
                let objectUpdate = result[0] as! NSManagedObject
                
                objectUpdate.setValue(address.id, forKey: "id")
                objectUpdate.setValue(address.title, forKey: "title")
                objectUpdate.setValue(address.address, forKey: "address")
                objectUpdate.setValue(address.street, forKey: "street")
                objectUpdate.setValue(address.area, forKey: "area")
                objectUpdate.setValue(address.floor, forKey: "floor")
                
                do{
                    try context.save()
                    return true
                }
                catch {
                    print("address updation error: \(error.localizedDescription)")
                    return false
                }
            }
        } catch {
            print("address not found")
        }
        
        return false
    }
    
    //    //MARK: - Delete All Address
    
    public func deleteAllAddress(){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.addressEntityName)
        let context = CoreDataPersistenceServices.context
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            print("All address deleted")
        } catch {
            print("address not found")
        }
        
    }
    
    
    //MARK: - Delete Address By Id
    
    
    public func deleteAddressById(addressId: Int){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.addressEntityName)
        fetchRequest.predicate = NSPredicate.init(format: "id == %d", addressId)
        
        let context = CoreDataPersistenceServices.context
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            print("address deleted")
        } catch {
            print("address not found")
        }
        
    }
    
   
}
