//
//  AppDelegate.swift
//  EmoRestaurant
//
//  Created by Xinxing Jiang on 3/3/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // connect app to Parse
        Parse.setApplicationId("zrLR5lJqr7MdryplpTQTF0KzqVVz4zEhxBIdWYYm", clientKey: "1nwUB5glhl1FntiqmRjZ92U0y70jjmiicTHUuTTn")
        
        var query =  PFQuery(className: "Restaurants")
        query.whereKey("RestaurantName", equalTo: "ShaoShanChong")
        query.findObjectsInBackgroundWithBlock { (ObjectArray, Error) in
            
             var picture = ObjectArray.first as PFObject
            var imageURL = DemoURL.NASA.Earth
            if let url =  imageURL{
                let imageData = NSData(contentsOfURL: url)
                let imageFile = PFFile(name:"Earth.jpg",data: imageData)
                picture["ProfileImage"] = imageFile
                picture.saveInBackgroundWithBlock { (success, error) in
                    
                }

           }
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

