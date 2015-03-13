//
//  TabBarViewController.swift
//  EmoRestaurant
//
//  Created by Xinxing Jiang on 3/7/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    // model for segue back from other tab views
    var preselectedIndex: Int?
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = true
        if let index = preselectedIndex {
            self.selectedIndex = index
        }
    }    
}
