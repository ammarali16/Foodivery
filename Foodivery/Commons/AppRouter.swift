//
//  AppRouter.swift
//  Foodivery
//
//  Created by Admin on 2/4/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import Foundation

class AppRouter {
    
    public static var storyboarName: String {
        get{
            if GlobalSharedResources.isIphone {
                return "Main"
            }else{
                return "Main_iPad"
            }
        }
    }
    
    //MARK: - Segues
    
    //Get Started
    public static let toHomeViewController = "toHomeViewController"
    
    
    //Find Islamic Center
    public static let toFindIslamicCenterViewController = "toFindIslamicCenterViewController"
    

    //MARK: - View Controller Identifiers

    public static let toItemsViewController = "toItemsViewController"
    public static let toForgetPasswordViewController = "toForgetPasswordViewController"
    public static let toFoodItemDetailViewController = "toFoodItemDetailViewController"
    public static let NotificationsViewControllerIdentifier = "NotificationsViewController"
    public static let toPaymentViewController = "toPaymentViewController"
    public static let toAddressBookViewController = "toAddressBookViewController"
    public static let toAddAddressViewController = "toAddAddressViewController"
    public static let toChangePasswordViewController = "toChangePasswordViewController"
    public static let toProfileViewController = "toProfileViewController"
    public static let toContactNumberViewController = "toContactNumberViewController"
    public static let toVerifyContactViewController = "toVerifyContactViewController"
    public static let toUserNameViewController = "toUserNameViewController"
    public static let toTermsAndConditionController = "toTermsAndConditionController"
    
}
