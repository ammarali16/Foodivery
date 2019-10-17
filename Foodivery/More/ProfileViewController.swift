//
//  ProfileViewController.swift
//  Foodivery
//
//  Created by Admin on 3/23/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import UIKit
import MRProgress

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageViewProfilePic: UIImageView!
    @IBOutlet weak var btnChangeImage: UIButton!
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfContactNumber: UITextField!
    @IBOutlet weak var tfEmai: UITextField!
    
    var imagePicker: UIImagePickerController!
    
    var viewModel: ProfileViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configurePickerView()
        self.viewModel = ProfileViewModelImp()
        self.viewModel.httpResponseHandler = self
        
        backButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true
        
        setupUI()
        settingValues()
        backButton()
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    func setupUI(){
        
        self.btnChangeImage.setImage(#imageLiteral(resourceName: "btn_camera").getOverlayImage(withColor: .white), for: .normal)
        self.btnChangeImage.backgroundColor = UIColor.lightGray
    }
    
    func backButton(){
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
    }
    
    func settingValues(){
        
        guard let userData = AppDefaults.userData else { return }
        
        if let profile_image = userData.imageUrl {
            self.imageViewProfilePic.setImage(urlString: profile_image, placeHoder: #imageLiteral(resourceName: "profileImagePlaceHolder"))
        }else{
            self.imageViewProfilePic.image = #imageLiteral(resourceName: "profileImagePlaceHolder")
            self.imageViewProfilePic.setOverlay(withColor: UIColor.gray)
        }
        
        self.tfEmai.text = userData.email
        
        
        if let userName = AppDefaults.userData?.name {
        self.tfUserName.text = userData.name
        }else{
            self.tfUserName.text = "Enter Name"
        }
        
        
        if let phoneNumber = AppDefaults.userData?.contact {
            self.tfContactNumber.text = phoneNumber
        }else{
            self.tfContactNumber.text = "Enter Number"
        }
        
        
    }
    
    
    @IBAction func unwindToProfile(_ sender: UIStoryboardSegue){}
    
    @IBAction func contactNumberButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: AppRouter.toContactNumberViewController, sender: nil)
    }
    
    
    @IBAction func userNameButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: AppRouter.toUserNameViewController, sender: nil)
    }
    
    
    
    @IBAction func btnEditProfilePicturePressed(_ sender: Any) {
        
        let alertController = UIAlertController.init(title: "Get Image", message: "Get your image from one of the following:", preferredStyle: UIDevice.current.userInterfaceIdiom == .phone ? .actionSheet : .alert)
        
        let alertActionCamera = UIAlertAction.init(title: "Camera", style: .default, handler: { action in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        })
        
        let alertActionGallery = UIAlertAction.init(title: "Gallery", style: .default, handler: { action in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let alertActionRemoveImage = UIAlertAction.init(title: "Remove Photo", style: .default, handler: { action in
            guard Connectivity.isConnectedToInternet() else {
                Alert.showNoInternetAlert(vc: self)
                return
            }
//            if let imageId = AppDefaults.userData?.imageUrl.id {
//                Loader.showLoader(viewController: self)
//                //self.viewModel.deletedProfilePic(imageId: imageId)
//            }
        })
        
        let alertActionCancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(alertActionCamera)
        alertController.addAction(alertActionGallery)
        alertController.addAction(alertActionRemoveImage)
        alertController.addAction(alertActionCancel)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func configurePickerView(){
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = true
    }
    
    
    @IBAction func btnChangePasswordPressed(_ sender: Any) {
        performSegue(withIdentifier: AppRouter.toChangePasswordViewController, sender: nil)
    }
    
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.uploadImage(image: pickedImage)
            })
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(image: UIImage){
        
        guard Connectivity.isConnectedToInternet() else {
            Alert.showNoInternetAlert(vc: self)
            return
        }
        
        if let imageData = image.compressedData() {
            self.showLoader()
            self.viewModel.updateProfileImage(imageData: imageData)
        }else{
            Alert.showAlert(vc: self, title: "Error!", message: "Something went wrong.")
        }
    }
}


extension ProfileViewController: HTTPResponseDelegate {
    
    func httpRequestFinishWithSuccess(response: Any, service: HTTPServices) {
        
        Loader.dismissLoader(viewController: self)
        
        switch service {
            
        case .setProfilePic:
            Loader.dismissLoader(viewController: self)
            self.settingValues()
            
//        case .deletedProfilePic:
//            if let message = response as? String {
//                NotificationCenter.default.post(name: .updateInfo, object: nil)
//                self.imageViewProfilePic.image = #imageLiteral(resourceName: "profileImagePlaceHolder")
//                self.imageViewProfilePic.setOverlay(withColor: AppColor.primaryColor)
//                Alert.showAlert(vc: self, title: "Success!", message: message)
//            }
        default:
            print("nothing")
        }
    }
    
    func httpRequestFinishWithError(message: String, service: HTTPServices) {
        
        Loader.dismissLoader(viewController: self)
        
        switch service {
        case .setProfilePic:
            Alert.showAlert(vc: self, title: "Error!", message: message)
        default:
            print("nothing")
        }
    }
    
}
