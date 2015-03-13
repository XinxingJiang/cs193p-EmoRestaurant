//
//  Constants.swift
//  EmoRestaurant
//
//  Created by Xinxing Jiang on 3/7/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import Foundation

struct Error {
    static let NetworkErrorCode = 100
    static let NetworkErrorMessage = "Network error"
    static let InvalidLoginParameterErrorCode = 101
    static let InvalidLoginParameterErrorMessage = "Invalid username or password"
    static let UsernameExistErrorCode = 202
    static let UsernameExistErrorMessage = "Username already exists"
    static let UnknownErrorMessage = "Unknown error"
    static let UnknownPlace = "Unknown Place"
    static let PleaseTryAgainLater = "Please try again later"
}

struct StoryBoard {
    static let GoBackToWelcomeSegueIdentifier = "Go Back to Welcome"
    static let GoBackToAccountSegueIdentifier = "Go Back to Account"
    static let SearchResult = "Search Result"
    static let BestRestaurant = "Best Restaurant"
    static let ShowARestaurant = "Show a Restaurant"
    static let EmbeddedComments = "Embedded Comments"
    static let CommentCell = "Comment Cell"
    static let WriteComment = "Write Comment"
}

struct Database {
    static let Restaurant = "Restaurant"
    static let RestaurantName = "RestaurantName"
    static let RestaurantCategory = "RestaurantCategory"
    static let Feature = "Feature"
    static let ProfileImage = "ProfileImage"
    static let UserAndRestaurant = "UserANDRestaurant"
    static let Username = "UserName"
    static let Signature = "Signature"
    static let Comments = "Comments"
    static let Comment = "Comment"
    static let CommentNumber = "CommentNumber"
    static let Content = "Content"
    static let Phone = "Phone"
    static let AddressDetail = "AddressDetail"
    static let City = "City"
    static let State = "State"
    static let Zipcode = "Zipcode"
    static let Longitude = "Longitude"
    static let Latitue = "Latitude"
}

struct Stepper {
    static let MinHappiness = 1
    static let MaxHappiness = 5
    static let DefaultHappiness = 3
    static let MinWeather = 1
    static let MaxWeather = 5
    static let DefaultWeather = 3
    static let MinPeople = 1
    static let MaxPeople = 12
    static let DefaultPeople = 4
}

struct RestaurantCategory {
    static let Values = ["American", "Chinese", "Japanese"]
}

struct Map {
    static let RegionDistance: CLLocationDistance = 10000
}