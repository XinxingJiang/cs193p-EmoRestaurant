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
        fetchAddress()
        fetchName()
    }
    
    //get from segue
    var restaurantInfo :PFObject?
    
    //datasources
    var longitude: Double?
    
    var latitude: Double?
    
    var addressString: String?
    
    var nameString: String?
    
    var restaurantComments: [String] = []
    
    private struct Storyboard {
        static let MainReuseIdentifier = "Main"
        static let CommentsReuserIdentifier = "Comments"
    }
    
    // MARK : -
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
    
    // MARK : -
    func fetchAddress(){
        var address = self.restaurantInfo!.objectForKey("AddressDetail") as? String
        var city = self.restaurantInfo!.objectForKey("City") as? String
        var state = self.restaurantInfo!.objectForKey("State") as? String
        var zip = self.restaurantInfo!.objectForKey("Zip") as? String
        var long = self.restaurantInfo?.objectForKey("Longitude") as? String
        longitude = NSNumberFormatter().numberFromString(long!)?.doubleValue
        var lat = self.restaurantInfo?.objectForKey("Latitude") as? String
        latitude = NSNumberFormatter().numberFromString(lat!)?.doubleValue
        addressString = "\(address!)" + "," + "\(city!)" + "," + "\(state!)\(zip!)"
    }
   
    // MARK : -
    func fetchName(){
        nameString = self.restaurantInfo!.objectForKey("RestaurantName") as? String
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
            height = CGFloat(180)
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
            cell.restaurantAddress = addressString
            var left = UISwipeGestureRecognizer(target: self, action: "swipping:")
            left.direction = UISwipeGestureRecognizerDirection.Left
            cell.addGestureRecognizer(left)
            return cell
        }
        
        if(sectionNo == 1){
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CommentsReuserIdentifier, forIndexPath: indexPath) as DisplayCommentsTableViewCell
            if(cellIndex < restaurantComments.count){
                cell.commentsLabel.text! = "'" + "\(restaurantComments[cellIndex])" + "'"
                cellIndex++
            }
        }
        
        return UITableViewCell()
    }
    
    // MARK : -
    func swipping (gesture : UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Left:
                 self.performSegueWithIdentifier("map", sender: self)
            default:
                break
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier{
            
            switch identifier{
            case "map":
                // Set up destination view controller
                if let DetailVC = segue.destinationViewController as? MapViewController {
                    DetailVC.longitude = longitude
                    DetailVC.latitude = latitude
                    DetailVC.nameString = nameString
                }
                
            case "comments":
                // Set up destination view controller
                let cell = sender as DisplayCommentsTableViewCell
                if let indexPath = tableView.indexPathForCell(cell){
                    if let DetailVC = segue.destinationViewController as? CommentsViewController {
                        DetailVC.comment = cell.commentsLabel.text!
                    }
                }
                
            default: break
            }
            
        }
    }

}
