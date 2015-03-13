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
        registerButton.setStyle(borderWidth: 1.0, borderColor: UIColor.grayColor().CGColor, backgroundColor: UIColor.grayColor(), tintColor: UIColor.whiteColor())
        loginButton.setStyle(borderWidth: 1.0, borderColor: UIColor.blueColor().CGColor, backgroundColor: UIColor.blueColor(), tintColor: UIColor.whiteColor())
        
//        let backgroundImage = UIImage(named: "background_stanford")!
//        let backgroundImageView = UIImageView(image: backgroundImage)
//        backgroundImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
//        view.addSubview(backgroundImageView)
//        view.addConstraint(backgroundImageView.auto)
//        self.
//        
//            UIImageView* imgView = UIImageView(image: myUIImage)
//        imgView.setTranslatesAutoresizingMaskIntoConstraints(false)
//        self.view.addSubview(imgView)
//        self.view.addConstraints(imgView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0,0,0,0))
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = true
    }
    
    @IBAction func goBackToWelcome(segue: UIStoryboardSegue) {
        
    }
}
