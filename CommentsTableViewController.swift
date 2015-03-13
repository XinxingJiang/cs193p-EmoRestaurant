//
//  CommentsTableViewController.swift
//  EmoRestaurant
//
//  Created by Xinxing Jiang on 3/13/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class CommentsTableViewController: UITableViewController {

    // MARK: - Model
    
    var restaurantName: String?
    
    var comments: [String]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // refresh commenrts
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var query = PFQuery(className: Database.Comment)
        query.whereKey(Database.RestaurantName, equalTo: restaurantName!)
        query.findObjectsInBackgroundWithBlock { (data, error) in
            if error == nil {
                var temp = [String]()
                if let result = data as? [PFObject] {
                    for item in result {
                        temp.append(item.valueForKey(Database.Content) as String)
                    }
                    self.comments = temp
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.CommentCell, forIndexPath: indexPath) as CommentCellView
        cell.commentLabel.text = comments?[indexPath.row] ?? ""
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}