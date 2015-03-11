//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by CS193p Instructor.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//  NSRange , UICOLOR

import UIKit

class DisplayMainTableViewCell: UITableViewCell
{
    var restaurantInfo: PFObject? {
        didSet {
            fetchData()
        }
    }
    
    @IBOutlet weak var restaurantImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var phone: UILabel!
    
    
    var restaurantName: String?
    var imageData: NSData?
    var restaurantAddress: String?
    var restaurantPhone: String?

    
    func fetchData(){
        let qos = Int(QOS_CLASS_USER_INITIATED.value)
        dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
            var imageFile = self.restaurantInfo!.objectForKey("ProfileImage") as PFFile
            let imageData = imageFile.getData()
            let nameLabelNew = self.restaurantInfo!.objectForKey("RestaurantName") as String
            let restaurantAddress = self.restaurantInfo!.objectForKey("Address") as String
            let restaurantPhone = self.restaurantInfo!.objectForKey("Phone") as String
            dispatch_async(dispatch_get_main_queue()) {
                self.nameLabel.text = nameLabelNew
                self.restaurantImage.image = UIImage(data: imageData!)
                self.address.text = restaurantAddress
                self.phone.text = restaurantPhone
            }
        }
    }
    

}
