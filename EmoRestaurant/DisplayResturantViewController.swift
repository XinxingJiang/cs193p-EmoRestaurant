//
//  DisplayResturantViewController.swift
//  EmoRestaurant
//
//  Created by YUE on 2/3/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class DisplayResturantViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchComments()
    }
    
    // Lazy instantiation for names of restaurants
    var restaurantInfo :PFObject?{
        didSet{
        }
    }
    
    func fetchComments(){
        let qos = Int(QOS_CLASS_USER_INITIATED.value)
        dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
            var comments: AnyObject? = self.restaurantInfo!.objectForKey("Comments")
            if (comments != nil){
                var newComments = comments as [String]
                self.restaurantComments = newComments
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    var restaurantComments: [String] = []
    
    private struct Storyboard {
        static let MainReuseIdentifier = "Main"
        static let CommentsReuserIdentifier = "Comments"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var row: Int! = 1
        if (section == 0){
            row = 1
        } else if (section == 1){
            var commentsCount: Int? = 0
            if(!restaurantComments.isEmpty){
                commentsCount = restaurantComments.count
            }
            row = commentsCount
        }
        return row
    }
    
    var cellIndex: Int = 0
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height: CGFloat?
        var section = indexPath.section
        if (section == 0){
            height = CGFloat(200)
        }
        if (section == 1){
            height = CGFloat(100)
        }
        return height ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var sectionNo = indexPath.section
        var rowNo = indexPath.row
        
        if(sectionNo == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.MainReuseIdentifier, forIndexPath: indexPath) as DisplayMainTableViewCell
            cell.restaurantInfo = restaurantInfo
            println("section 0: ")
            println("rowNo: " + "\(rowNo)")
            return cell
        }
        
        if(sectionNo == 1){
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CommentsReuserIdentifier, forIndexPath: indexPath) as UITableViewCell
            if(cellIndex < restaurantComments.count){
                cell.textLabel?.text = restaurantComments[cellIndex]
                cellIndex++
            }
            println("section 1: ")
            println("rowNo: " + "\(rowNo)")
            return cell
        }
        
        println("random........")
        return UITableViewCell()
    }

}
