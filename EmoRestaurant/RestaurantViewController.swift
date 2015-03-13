//
//  RestaurantViewController.swift
//  EmoRestaurant
//
//  Created by YUE on 2/3/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit
import MapKit

class RestaurantViewController: UIViewController {
    
    var isFavorite: Bool? {
        didSet {
            if isFavorite != nil {
                if isFavorite! {
                    favoritesButton.setTitle(Constants.RemoveFromFavorites, forState: UIControlState.Normal)
                } else {
                    favoritesButton.setTitle(Constants.AddToFavorite, forState: UIControlState.Normal)
                }
            }
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setup() // initialize name, address, image
        checkIsFavorite()
    }
    
    // MARK: - Model
    
    var restaurant: PFObject?
    
    // MARK: - Setup
    
    private func setup() {
        if restaurant != nil {
            nameLabel.text = restaurant!.objectForKey(Database.RestaurantName) as? String ?? ""
            phoneLabel.text = restaurant!.objectForKey(Database.Phone) as? String ?? ""
            if let imageFile = restaurant!.objectForKey(Database.ProfileImage) as? PFFile {
                let qos = Int(QOS_CLASS_USER_INITIATED.value)
                dispatch_async(dispatch_get_global_queue(qos, 0)) { [weak self] in
                    if let imageData = imageFile.getData() {
                        if let image = UIImage(data: imageData) {
                            dispatch_async(dispatch_get_main_queue()) {
                                self!.imageView.image = image
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Favorites
    
    // whether this restaurant is in user's favorites
    private func checkIsFavorite() {
        var query = PFQuery(className: Database.UserAndRestaurant)
        query.whereKey(Database.Username, equalTo: PFUser.currentUser().username)
        query.whereKey(Database.Restaurant, equalTo: nameLabel.text)
        query.findObjectsInBackgroundWithBlock { (data, error) in
            if error == nil {
                if !data.isEmpty { // is favorite
                    self.isFavorite = true
                } else {
                    self.isFavorite = false
                }
            }
        }
    }
    
    // if the restaurant is in favorites, remove it
    // otherwise, add it to favorite
    @IBAction func flipFavorite() {
        if isFavorite != nil {
            if isFavorite! { // remove from favorite
                var query = PFQuery(className: Database.UserAndRestaurant)
                query.whereKey(Database.Username, equalTo: PFUser.currentUser().username)
                query.whereKey(Database.Restaurant, equalTo: nameLabel.text)
                query.findObjectsInBackgroundWithBlock { (data, error) in
                    if error == nil {
                        if let result = data as? [PFObject] {
                            result.first?.deleteInBackgroundWithBlock { (_, error) in
                                if error == nil {
                                    var alert = UIAlertController(title: "Success!", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                                    alert.addAction(UIAlertAction(title: "Back", style: .Cancel, handler: nil))
                                    self.presentViewController(alert, animated: true, completion: nil)
                                } else {
                                    var alert = UIAlertController(title: "Error!", message: Error.PleaseTryAgainLater, preferredStyle: UIAlertControllerStyle.Alert)
                                    alert.addAction(UIAlertAction(title: "Back", style: .Cancel, handler: nil))
                                    self.presentViewController(alert, animated: true, completion: nil)
                                }
                            }
                        }
                        self.checkIsFavorite()
                    }
                }
            } else { // add to favorite
                var favorite = PFObject(className: Database.UserAndRestaurant)
                favorite[Database.Username] = PFUser.currentUser().username
                favorite[Database.Restaurant] = nameLabel.text ?? ""
                favorite.saveInBackgroundWithBlock { (_, error) in
                    if error == nil {
                        var alert = UIAlertController(title: "Success", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                    self.checkIsFavorite()
                }
            }
            
        }
    }
    
    // MARK: - Get Direction
    
    // open Apple Map
    @IBAction func getDirection() {
        let longitude = restaurant?.objectForKey(Database.Longitude) as? CLLocationDistance ?? 0.0
        let latitude = restaurant?.objectForKey(Database.Latitue) as? CLLocationDistance ?? 0.0
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let regionDistance: CLLocationDistance = Map.RegionDistance
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        var placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        var mapItem = MKMapItem(placemark: placemark)
        mapItem.name = nameLabel.text ?? Error.UnknownPlace
        mapItem.openInMapsWithLaunchOptions(options)
    }
    
    // MARK: - Navigation
    
    @IBAction func goBackToRestaurant(segue: UIStoryboardSegue) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case StoryBoard.EmbeddedComments:
                if let ctvc = segue.destinationViewController as? CommentsTableViewController {
                    let restaurantName = restaurant!.valueForKey(Database.RestaurantName) as String
                    ctvc.restaurantName = restaurantName
                }
            case StoryBoard.WriteComment:
                if let wcvc = segue.destinationViewController as? WriteCommentViewController {
                    wcvc.restaurantName = nameLabel.text
                }
            default:
                break
            }
        }
    }
    
    // MARK: - Constants
    
    private struct Constants {
        static let AddToFavorite = "Add to Favorites"
        static let RemoveFromFavorites = "Remove from Favorites"
    }
}