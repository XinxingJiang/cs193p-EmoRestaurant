//
//  AccountViewController.swift
//  EmoRestaurant
//
//  Created by Xinxing Jiang on 3/4/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var signatureLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = PFUser.currentUser().username
        if let signature = PFUser.currentUser().valueForKey(Constants.SignatureKey) as? String {
            signatureLabel.text = signature
        } else {
            signatureLabel.text = Constants.DefaultSignature
            signatureLabel.textColor = UIColor.grayColor()
        }
        navigationController?.navigationBarHidden = true
        logoutButton.layer.borderWidth = 1.0
        logoutButton.layer.borderColor = UIColor.blueColor().CGColor
        logoutButton.layer.borderWidth = 1.0
        logoutButton.layer.borderColor = UIColor.redColor().CGColor
    }
    
    @IBAction func edit() {
        
    }
    
    @IBAction func loggout() {
        PFUser.logOut()
    }
    
    private struct Constants {
        static let SignatureKey = "Signature"
        static let DefaultSignature = "You do not have a signature."
    }
}
