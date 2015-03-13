//
//  WelcomeViewController.swift
//  EmoRestaurant
//
//  Created by Xinxing Jiang on 3/4/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // hide the navigation bar
        navigationController?.navigationBarHidden = true
        registerButton.setStyle(borderWidth: 1.0, borderColor: UIColor.blueColor().CGColor)
        loginButton.setStyle(borderWidth: 1.0, borderColor: UIColor.blueColor().CGColor)
    }
    
    @IBAction func goBackToWelcome(segue: UIStoryboardSegue) {
        
    }
}
