//
//  AddressTableViewCell.swift
//  Foodivery
//
//  Created by Admin on 3/21/19.
//  Copyright © 2019 Mujadidia Inc. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell {


    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var textViewAddress: UITextView!
    @IBOutlet weak var addressImageView: UIImageView!
    
    func configureCell(obj: Address){
        
        if let title = obj.title {
        self.titleLbl.text = title
        }
        
        if let address = obj.address, let street = obj.street, let area = obj.area, let floor = obj.floor {
            let combinedAddress = "\(address)  \(street)  \(area)  \(floor)"
            self.textViewAddress.text = combinedAddress
        }
        
        if obj.id == AppDefaults.defaultAddressId {
            self.addressImageView?.image = #imageLiteral(resourceName: "check_state")
        }else{
            self.addressImageView?.image = #imageLiteral(resourceName: "uncheck_state")
        }
        
    }
    
}
