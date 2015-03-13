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
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = true
        usernameLabel.text = PFUser.currentUser().username
        editButton.setStyle(borderWidth: 1.0, borderColor: UIColor.blueColor().CGColor)
        changePasswordButton.setStyle(borderWidth: 1.0, borderColor: UIColor.blueColor().CGColor)
        logoutButton.setStyle(borderWidth: 1.0, borderColor: UIColor.redColor().CGColor)
        updateProdileImage()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let signature = PFUser.currentUser().valueForKey(Database.Signature) as? String {
            signatureLabel.text = signature
        } else {
            signatureLabel.text = Constants.DefaultSignature
            signatureLabel.textColor = UIColor.grayColor()
        }
        navigationController?.navigationBarHidden = true
    }
    
    // MARK: - Log out
    
    @IBAction func loggout() {
        PFUser.logOut()
    }
    
    @IBAction func goBackToAccount(segue: UIStoryboardSegue) {
    
    }

    // MARK: - Profile Image
    
    private func updateProdileImage() {
        let currentUser = PFUser.currentUser()
        if let imageFile = currentUser.objectForKey(Database.ProfileImage) as? PFFile {
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
    
    // MARK: - Constants
        
    struct Constants {
        static let DefaultSignature = "You do not have a signature."
    }
}
