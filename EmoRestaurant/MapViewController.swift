//
//  ImageViewController.swift
//  EmoRestaurant
//
//  Created by YUE on 3/3/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBook
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    var locationManager = CLLocationManager()
    var longitude: Double?
    var latitude: Double?
    var addressString: String?
    var nameString: String?
    
    // MARK : -
    override func viewDidLoad() {
        super.viewDidLoad()
        //        getDirections()
        self.map.mapType = MKMapType.Standard
        self.map.showsUserLocation = true
        self.map.removeAnnotations(self.map.annotations)
        self.locationManager.requestAlwaysAuthorization()
        
        // getUser's Location
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            // var locValue:CLLocationCoordinate2D = locationManager.location.coordinate
            // println("locations = \(locValue.latitude) \(locValue.longitude)")
        }
        getDestinationPoint()
    }
    
    // MARK : -
    func getDestinationPoint(){
        var coordinates:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
        var pointAnnotation:MKPointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinates
        pointAnnotation.title = nameString
        pointAnnotation.subtitle = addressString
        
        self.map.addAnnotation(pointAnnotation)
        self.map.centerCoordinate = coordinates
        self.map.selectAnnotation(pointAnnotation, animated: true)
        
        var latDelta:CLLocationDegrees = 0.2
        var longDelta:CLLocationDegrees = 0.2
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        var region:MKCoordinateRegion = MKCoordinateRegionMake(coordinates, span)
        self.map.setRegion(region, animated: true)
    }
}


//    
//    func getDirections(){
//        let geoCoder = CLGeocoder()
//        let addressString = "\(address) \(city) \(state) \(zip)"
//        geoCoder.geocodeAddressString(addressString, completionHandler:
//            {(placemarks: [AnyObject]!, error: NSError!) in
//                if error != nil {
//                    println("Geocode failed with error: \(error.localizedDescription)")
//                } else if placemarks.count > 0 {
////                    let placemark = placemarks[0] as CLPlacemark
////                    let location = placemark.location
////                    self.coords = location.coordinate
//
//
//                    
////                    var placemark:CLPlacemark = placemarks[0] as CLPlacemark
////                    var coordinates:CLLocationCoordinate2D = placemark.location.coordinate
////                    
////                    var pointAnnotation:MKPointAnnotation = MKPointAnnotation()
////                    pointAnnotation.coordinate = coordinates
////                    pointAnnotation.title = "Apple HQ"
////                    
////                    self.map.addAnnotation(pointAnnotation)
////                    self.map.centerCoordinate = coordinates
////                    self.map.selectAnnotation(pointAnnotation, animated: true)
////                    
////                    println("Added annotation to map view")
////                    self.showMap()
//                    
//                }
//        })
//    }
//    
//    func showMap() {
//        let addressDict =
//        [kABPersonAddressStreetKey as NSObject: address!,
//            kABPersonAddressCityKey as NSObject: city!,
//            kABPersonAddressStateKey as NSObject: state!,
//            kABPersonAddressZIPKey as NSObject: zip!]
//        
//        let place = MKPlacemark(coordinate: coords!,
//            addressDictionary: addressDict)
//        
//        let mapItem = MKMapItem(placemark: place)
//        
//        let options = [MKLaunchOptionsDirectionsModeKey:
//        MKLaunchOptionsDirectionsModeDriving]
//        
//        mapItem.openInMapsWithLaunchOptions(options)
//    }
//
//}
