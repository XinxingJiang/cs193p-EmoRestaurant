//
//  SearchResultViewController.swift
//  EmoRestaurant
//
//  Created by YUE on 2/3/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class SearchResultViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Constants
    
    private struct Constants {
        static let CellReuseIdentifier = "SearchResultViewCell"
//        static let HeaderReuserIdentifier = "Header"
    }
    
    // MARK: Model
    var restaurants: [PFObject]?
    
    // MARK: - View Controller View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = false
    }
    
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    // MARK: Collection View Delegate
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurants?.count ?? 0
    }
    
    // configure cell
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.CellReuseIdentifier, forIndexPath: indexPath) as SearchResultCellView
        if let restaurant = restaurants?[indexPath.row] {
            if let imageFile = restaurant.objectForKey(Database.ProfileImage) as? PFFile {
                let imageData = imageFile.getData()
                let image = UIImage(data: imageData)
                cell.imageView.image = image
            }
            if let name = restaurant.objectForKey(Database.RestaurantName) as? String {
                cell.nameLabel.text = name
                cell.backgroundColor = UIColor.whiteColor()
            }
        }
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case StoryBoard.ShowARestaurant:
                if let rvc = segue.destinationViewController as? RestaurantViewController {
                    if let let indexPath = collectionView?.indexPathForCell(sender as SearchResultCellView) {
                        rvc.restaurant = restaurants?[indexPath.row]
                    }
                }
            default:
                break
            }
        }
    }
}