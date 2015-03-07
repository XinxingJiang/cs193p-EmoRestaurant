//
//  AccountViewController.swift
//  EmoRestaurant
//
//  Created by Xinxing Jiang on 3/4/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var signatureLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true // this line did not work
        usernameLabel.text = PFUser.currentUser().username
        if let signature = PFUser.currentUser().valueForKey(Constants.SignatureKey) as? String {
            signatureLabel.text = signature
        } else {
            signatureLabel.text = Constants.DefaultSignature
            signatureLabel.textColor = UIColor.grayColor()
        }
        editButton.layer.borderWidth = 1.0
        editButton.layer.borderColor = UIColor.blueColor().CGColor
        logoutButton.layer.borderWidth = 1.0
        logoutButton.layer.borderColor = UIColor.redColor().CGColor
        updateImage()
    }
    
    @IBAction func loggout() {
        PFUser.logOut()
    }
    
    private func updateImage() {
        let currentUser = PFUser.currentUser()
        if let imageFile = currentUser.objectForKey(Constants.ProfileImageKey) as? PFFile {
            let qos = Int(QOS_CLASS_USER_INITIATED.value)
            dispatch_async(dispatch_get_global_queue(qos, 0)) { [weak self] in
                if let imageData = imageFile.getData() {
                    if let image = UIImage(data: imageData) {
                        dispatch_async(dispatch_get_main_queue()) {
                            self!.imageView.image = image
                        }
                    }
                }
            }
        }
    }
        
    struct Constants {
        static let SignatureKey = "Signature"
        static let ProfileImageKey = "ProfileImage"
        static let DefaultSignature = "You do not have a signature."
    }
}
