//
//  CommentsViewController.swift
//  EmoRestaurant
//
//  Created by YUE on 11/3/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        commentsFull.text! = comment!
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var commentsFull: UILabel!

    var comment: String?
}
