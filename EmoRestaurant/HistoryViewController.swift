//
//  HistoryViewController.swift
//  EmoRestaurant
//
//  Created by YUE on 2/3/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class HistoryViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRestaurantData()
    }
    
    //model: dataSource that is set by "getRestaurantData()"
    var restaurantInfo :[PFObject] = []
    
    private struct Storyboard {
        static let CellReuseIdentifier = "HistoryCollectionViewCell"
        static let HeaderReuserIdentifier = "Header"
    }
    
    private var numberOfItemsInSection: Int?
    
    private var indexPathCollection: [NSIndexPath] = []
    
    var restaurantComments: [String] = []
    
    //tune layout for collectionViewCells
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    
    //tune layout for collectionViewCells cont'
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    // Number of items in section
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //get data for this user:
        var currentUser = PFUser.currentUser()
        numberOfItemsInSection = restaurantInfo.count
        return numberOfItemsInSection ?? 0
    }

    // used in the function below --- "collecitonView(....)"
    private var cellIndex:Int = 0
    
    // Set up each cell
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as HistoryCollectionViewCell
        
        if(indexPathCollection.count <= numberOfItemsInSection){
            indexPathCollection.append(indexPath)
        }
        
        // executed after model is fully set
        if(restaurantInfo.count == numberOfItemsInSection){
            // check the cellIndex is within the range, then set data to the cell
            // increase the cellIndex by 1 upon successful execution
            if(cellIndex < numberOfItemsInSection){
                var index = cellIndex
                let qos = Int(QOS_CLASS_USER_INITIATED.value)
                dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                    var imageFile = self.restaurantInfo[index].objectForKey("ProfileImage") as PFFile
                    var imageData = imageFile.getData()
                    let image = UIImage(data: imageData)
                    let nameLabel = self.restaurantInfo[index].objectForKey("RestaurantName") as String
                    dispatch_async(dispatch_get_main_queue()) {
                        cell.imageView.image = image
                        cell.title.text = nameLabel
                        cell.backgroundColor = UIColor.whiteColor()
                    }
                }
                cellIndex++
            }
        }
        
        return cell
    }
    
    // fetch data from database and feed it into the model :"restaurantInfo"
    private func getRestaurantData() {
        
        var currentUser = PFUser.currentUser()
        var query = PFQuery(className: "UserANDRestaurant")
        query.whereKey("UserName",equalTo: currentUser.username)
        query.findObjectsInBackgroundWithBlock { (ObjectArray, Error) in
            
            println(Error)
            var results:[PFObject] = []
            results = ObjectArray as [PFObject]
            
            //set the numberOfItemsInSection
            self.numberOfItemsInSection = results.count
            
            for i in 0 ..< results.count{
                var name = results[i].objectForKey("Restaurant") as String
                var query2 = PFQuery(className: "Restaurant")
                query2.whereKey("RestaurantName", equalTo: name)
                query2.findObjectsInBackgroundWithBlock { (ObjectArray2, Error) in
                    var results2 = ObjectArray2 as [PFObject]
                    var result: PFObject = results2.first!
                    self.restaurantInfo.append(result)
                    
                    //when the model is fully set, call reloadData to trigger collectionView(...) again and reload the cell
                    //only called once
                    if(self.restaurantInfo.count == self.numberOfItemsInSection){
                        self.collectionView?.reloadData()
                    }
                }
            }
        }
    }
    

    
    // Number of sections
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Set up header section in collectionView
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: Storyboard.HeaderReuserIdentifier, forIndexPath: indexPath) as UICollectionReusableView
            
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
        
    }
    
    // Segue to DisplayResturantViewController via NavigationViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get indexPath for the selected cell
        let indexPath : NSIndexPath? = collectionView?.indexPathForCell(sender as HistoryCollectionViewCell)
        
        if segue.identifier == "Cell" {
            
            // Set up destination view controller
            var destination = segue.destinationViewController as? UIViewController
            if let navCon = destination as? UINavigationController {
                destination = navCon.visibleViewController
            }
            if let DetailVC = destination as? DisplayResturantViewController {
                if let index = indexPath?.row {
                    DetailVC.restaurantInfo = restaurantInfo[index]

                }
            }
        }
        
    }
}

//        var query =  PFQuery(className: "Restaurant")
//        query.whereKey("RestaurantName", equalTo: "HongKongRestaurant @ Palo Alto")
//        query.findObjectsInBackgroundWithBlock { (ObjectArray, Error) in
//
//            var restarunt = ObjectArray.first as PFObject
//            var list: [String] = ["cat","dog","hippo"]
//            restarunt.setObject(list, forKey: "Comments")
//            restarunt.saveInBackgroundWithBlock { (success, error) in
//            }
//        }


//
//var query =  PFQuery(className: "Restaurants")
//query.whereKey("RestaurantName", equalTo: "Starbucks @ Stanford")
//query.findObjectsInBackgroundWithBlock { (ObjectArray, Error) in
//    println(ObjectArray)
//    var picture = ObjectArray.first as PFObject
//    println(picture.objectId)
//    var imageURL = DemoURL.NASA.StarbucksStanford
//    if let url =  imageURL{
//        let imageData = NSData(contentsOfURL: url)
//        let imageFile = PFFile(name:"Starbucks.jpg",data: imageData)
//        picture.setObject(imageFile, forKey: "ProfileImage")
//        picture.saveInBackgroundWithBlock { (success, error) in
//
//        }
//
//    }
//}
//
//var query2 =  PFQuery(className: "Restaurants")
//query2.whereKey("RestaurantName", equalTo: "HongKongRestaurant")
//query2.findObjectsInBackgroundWithBlock { (ObjectArray, Error) in
//    println(ObjectArray)
//    var picture = ObjectArray.first as PFObject
//    println(picture.objectId)
//    var imageURL = DemoURL.NASA.HongKongRestaurant
//    if let url =  imageURL{
//        let imageData = NSData(contentsOfURL: url)
//        let imageFile = PFFile(name:"HongKongRestaurant.jpg",data: imageData)
//        picture.setObject(imageFile, forKey: "ProfileImage")
//        picture.saveInBackgroundWithBlock { (success, error) in
//
//        }
//
//    }
//}
//var query3 =  PFQuery(className: "Restaurants")
//query3.whereKey("RestaurantName", equalTo: "SuHang @ Palo Alto")
//query3.findObjectsInBackgroundWithBlock { (ObjectArray, Error) in
//    println(ObjectArray)
//    var picture = ObjectArray.first as PFObject
//    println(picture.objectId)
//    var imageURL = DemoURL.NASA.Suhang
//    if let url =  imageURL{
//        let imageData = NSData(contentsOfURL: url)
//        let imageFile = PFFile(name:"Suhang.jpg",data: imageData)
//        picture.setObject(imageFile, forKey: "ProfileImage")
//        picture.saveInBackgroundWithBlock { (success, error) in
//
//        }
//
//    }
//}



//    func getProfileImages(){
//        var currentUser = PFUser.currentUser()
//        var query = PFQuery(className: "UserANDRestaurant")
//        query.whereKey("UserName",equalTo: currentUser.username)
//        query.findObjectsInBackgroundWithBlock { (ObjectArray, Error) in
//            println(Error)
//            var results:[PFObject] = []
//            results = ObjectArray as [PFObject]
//            while(!results.isEmpty){
//                var name: String = results.first?.objectForKey("Restaurant") as String
//                results.removeAtIndex(0)
//                println("restaurantName: " + name)
//                var query2 = PFQuery(className: "Restaurants")
//                query2.whereKey("RestaurantName", equalTo: name)
//                query2.findObjectsInBackgroundWithBlock { (ObjectArray2, Error) in
//                    var results2 = ObjectArray2 as [PFObject]
//
//                    let qos = Int(QOS_CLASS_USER_INITIATED.value)
//                    dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
//                        var imageFile = results2.first?.objectForKey("ProfileImage") as PFFile
//                        var imageData = imageFile.getData()
//                        dispatch_async(dispatch_get_main_queue()){
//                        self.imagesData.insert(imageData , atIndex: 0) // this blocks the thread it is on
//                        println("Inserted one image!")
//                        }
//                    }
//
//                }
//            }
//        }
//
//    }


//var query =  PFQuery(className: "Restaurant")
//query.whereKey("RestaurantName", equalTo: "Starbucks @ Stanford")
//query.findObjectsInBackgroundWithBlock { (ObjectArray, Error) in
//    println(ObjectArray)
//    var picture = ObjectArray.first as PFObject
//    println(picture.objectId)
//    var imageURL = DemoURL.NASA.StarbucksStanford
//    if let url =  imageURL{
//        let imageData = NSData(contentsOfURL: url)
//        let imageFile = PFFile(name:"Starbucks.jpg",data: imageData)
//        picture.setObject(imageFile, forKey: "ProfileImage")
//        picture.saveInBackgroundWithBlock { (success, error) in
//            
//        }
//        
//    }
//}
//
//var query2 =  PFQuery(className: "Restaurant")
//query2.whereKey("RestaurantName", equalTo: "HongKongRestaurant")
//query2.findObjectsInBackgroundWithBlock { (ObjectArray, Error) in
//    println(ObjectArray)
//    var picture = ObjectArray.first as PFObject
//    println(picture.objectId)
//    var imageURL = DemoURL.NASA.HongKongRestaurant
//    if let url =  imageURL{
//        let imageData = NSData(contentsOfURL: url)
//        let imageFile = PFFile(name:"HongKongRestaurant.jpg",data: imageData)
//        picture.setObject(imageFile, forKey: "ProfileImage")
//        picture.saveInBackgroundWithBlock { (success, error) in
//            
//        }
//        
//    }
//}
//var query3 =  PFQuery(className: "Restaurant")
//query3.whereKey("RestaurantName", equalTo: "SuHang @ Palo Alto")
//query3.findObjectsInBackgroundWithBlock { (ObjectArray, Error) in
//    println(ObjectArray)
//    var picture = ObjectArray.first as PFObject
//    println(picture.objectId)
//    var imageURL = DemoURL.NASA.Suhang
//    if let url =  imageURL{
//        let imageData = NSData(contentsOfURL: url)
//        let imageFile = PFFile(name:"Suhang.jpg",data: imageData)
//        picture.setObject(imageFile, forKey: "ProfileImage")
//        picture.saveInBackgroundWithBlock { (success, error) in
//            
//        }
//        
//    }
//}
