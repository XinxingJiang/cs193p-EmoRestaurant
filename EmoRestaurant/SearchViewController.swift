//
//  SearchViewController.swift
//  EmoRestaurant
//
//  Created by YUE on 2/3/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    @IBOutlet weak var happinessValueLabel: UILabel!
    @IBOutlet weak var weatherValueLabel: UILabel!
    @IBOutlet weak var peopleValueLabel: UILabel!
    @IBOutlet weak var happinessStepper: UIStepper!
    @IBOutlet weak var weatherStepper: UIStepper!
    @IBOutlet weak var peopleStepper: UIStepper!
    @IBOutlet weak var pickOneButton: UIButton!
    
    // MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHappinessStepper()
        setupWeatherStepper()
        setupPeopleStepper()
//        pickOneButton.setStyle(borderWidth: 1.0, borderColor: UIColor.blueColor().CGColor)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = true
    }
    
    // MARK: - Steppers
    
    private func setupHappinessStepper() {
        happinessStepper.minimumValue = Double(Stepper.MinHappiness)
        happinessStepper.maximumValue = Double(Stepper.MaxHappiness)
        happinessStepper.stepValue = 1
        happinessStepper.value = Double(Stepper.DefaultHappiness)
        happinessValueLabel.text = Stepper.DefaultHappiness.description
    }
    
    private func setupWeatherStepper() {
        weatherStepper.minimumValue = Double(Stepper.MinWeather)
        weatherStepper.maximumValue = Double(Stepper.MaxWeather)
        weatherStepper.stepValue = 1
        weatherStepper.value = Double(Stepper.DefaultWeather)
        weatherValueLabel.text = Stepper.DefaultWeather.description
    }
    
    private func setupPeopleStepper() {
        peopleStepper.minimumValue = Double(Stepper.MinPeople)
        peopleStepper.maximumValue = Double(Stepper.MaxPeople)
        peopleStepper.stepValue = 1
        peopleStepper.value = Double(Stepper.DefaultPeople)
        peopleValueLabel.text = Stepper.DefaultPeople.description
    }
    
    @IBAction func happinessChanged(sender: UIStepper) {
        happinessValueLabel.text = Int(sender.value).description
    }
    
    @IBAction func weatherChanged(sender: UIStepper) {
        weatherValueLabel.text = Int(sender.value).description
    }
    
    @IBAction func peopleChanged(sender: UIStepper) {
        peopleValueLabel.text = Int(sender.value).description
    }
    
    // MARK: - Pick One
    
    @IBAction func pickOne(sender: UIButton) {
        let happiness = happinessStepper.value
        let weather = weatherStepper.value
        let people = peopleStepper.value
        getBestRestaurant(happiness: happiness, weather: weather, people: people)
    }
    
    // unwind segue
    @IBAction func goBackToSearch(segue: UIStoryboardSegue) {
        
    }
    
    // MARK: - Search Bar Delegate

    // get called whenever user click Search in keyboard
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let keyword = searchBar.text
        getRestaurantsByName(keyword)
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Fetch Restaurant Data
    
    var bestRestaurant: PFObject? {
        didSet {
            if bestRestaurant != nil {
                performSegueWithIdentifier(StoryBoard.BestRestaurant, sender: nil)
            }
        }
    }

    var searchResults: [PFObject]? {
        didSet {
            if searchResults != nil {
                performSegueWithIdentifier(StoryBoard.SearchResult, sender: nil)
            }
        }
    }
    
    // return a restaurant which fits (happiness, weather, people) feature best based on vector distance
    private func getBestRestaurant(#happiness: Double, weather: Double, people: Double) {
        var query = PFQuery(className: Database.Restaurant)
        query.whereKeyExists(Database.RestaurantName) // get all restaurants
        query.findObjectsInBackgroundWithBlock { (data, error) in
            if error == nil {
                if let result = data as? [PFObject] {
                    var minDistance = Double(Int.max)
                    var bestRestaurant: PFObject? = nil
                    for restaurant in result {
                        if let feature = restaurant.valueForKey(Database.Feature) as? [Double] {
                            var distance = self.computeDistance(feature1: feature, feature2: [happiness, weather, people])
                            if distance != nil && distance! < minDistance {
                                minDistance = distance!
                                bestRestaurant = restaurant
                            }
                        }
                    }
                    self.bestRestaurant = bestRestaurant
                }
            } else {
                self.bestRestaurant = nil
            }
        }
    }

    // compute distance between two vectors
    private func computeDistance(#feature1: [Double], feature2: [Double]) -> Double? {
        if feature1.count != feature2.count {
            return nil
        }
        var distance = 0.0
        for i in 0..<feature1.count {
            distance += pow(Double(feature1[i] - feature2[i]), 2)
        }
        return distance
    }
    
    // return all restaurants whose name contains the keyword
    private func getRestaurantsByName(name: String) {
        var query = PFQuery(className: Database.Restaurant)
        query.whereKey(Database.RestaurantName, containsString: name)
        query.findObjectsInBackgroundWithBlock { (data, error) in
            if error == nil {
                if let result = data as? [PFObject] {
                    self.searchResults = result
                }
            } else {
                self.searchResults = nil
            }
        }
    }
    
    // get all restaurants whose category is the chosen category
    private func getRestaurantsByCategory(category: String) {
        var query = PFQuery(className: Database.Restaurant)
        query.whereKey(Database.RestaurantCategory, equalTo: category)
        query.findObjectsInBackgroundWithBlock { (data, error) in
            if error == nil {
                if let result = data as? [PFObject] {
                    self.searchResults = result
                }
            } else {
                self.searchResults = nil
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case StoryBoard.SearchResult:
                if let srvc = segue.destinationViewController as? SearchResultViewController {
                    srvc.restaurants = searchResults!
                }
            case StoryBoard.BestRestaurant:
                if let rvc = segue.destinationViewController as? RestaurantViewController {
                    rvc.restaurant = bestRestaurant
                }
            default:
                break
            }
        }
    }
}
