//
//  SearchResultTableViewController.swift
//  EmoRestaurant
//
//  Created by YUE on 3/3/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController, UITableViewDelegate {

    // MARK: - Model
    var restaurants: [PFObject]? {
        didSet {
            if restaurants != nil {
                performSegueWithIdentifier(StoryBoard.SearchResult, sender: nil)
            }
        }
    }
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let category = RestaurantCategory.Values[indexPath.row]
        var query = PFQuery(className: Database.Restaurant)
        query.whereKey(Database.RestaurantCategory, equalTo: category)
        query.findObjectsInBackgroundWithBlock { (data, error) in
            if error == nil {
                if let result = data as? [PFObject] {
                    self.restaurants = result
                }
            } else {
                self.restaurants = nil
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case StoryBoard.SearchResult:
                if let srvc = segue.destinationViewController as? SearchResultViewController {
                    srvc.restaurants = restaurants
                }
            default:
                break
            }
        }
    }
}
