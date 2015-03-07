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
    override func viewDidLoad() {
        super.viewDidLoad()
        // hide the navigation bar
        navigationController?.navigationBarHidden = true
        registerButton.layer.borderWidth = 1.0
        registerButton.layer.borderColor = UIColor.blueColor().CGColor
        loginButton.layer.borderWidth = 1.0
        loginButton.layer.borderColor = UIColor.blueColor().CGColor
    }
}
