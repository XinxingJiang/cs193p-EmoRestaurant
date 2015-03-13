//
//  WriteCommentViewController.swift
//  EmoRestaurant
//
//  Created by Xinxing Jiang on 3/13/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class WriteCommentViewController: UIViewController, UITextViewDelegate {

    var restaurantName: String?
    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.delegate = self
        }
    }
    @IBOutlet weak var happinessValueLabel: UILabel!
    @IBOutlet weak var weatherValueLabel: UILabel!
    @IBOutlet weak var peopleValueLabel: UILabel!
    @IBOutlet weak var happinessStepper: UIStepper!
    @IBOutlet weak var weatherStepper: UIStepper!
    @IBOutlet weak var peopleStepper: UIStepper!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.setStyle(borderWidth: 1.0, borderColor: UIColor.blackColor().CGColor)
        setupHappinessStepper()
        setupWeatherStepper()
        setupPeopleStepper()
//        submitButton.setStyle(borderWidth: 1.0, borderColor: UIColor.blueColor().CGColor)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = false
    }
    
    // MARK: Text View Delegate
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" { // if user clicks return, hide the keyword
            textView.resignFirstResponder()
        }
        return true
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
    
    // MARK: Submit
    
    @IBAction func submit() {
        // update restaurant feature
        var query = PFQuery(className: Database.Restaurant)
        query.whereKey(Database.RestaurantName, equalTo: restaurantName!)
        query.findObjectsInBackgroundWithBlock { (data, error) in
            if let result = data as? [PFObject] { // should be only 1 element
                if result.count == 1 {
                    let restaurant = result.first!
                    var feature = restaurant.valueForKey(Database.Feature) as [Double]
                    var commentNumber = restaurant.valueForKey(Database.CommentNumber) as Double
                    feature[0] = (feature[0] * commentNumber + self.happinessStepper.value) / (commentNumber + 1)
                    feature[1] = (feature[1] * commentNumber + self.weatherStepper.value) / (commentNumber + 1)
                    feature[2] = (feature[2] * commentNumber + self.peopleStepper.value) / (commentNumber + 1)
                    commentNumber += 1
                    restaurant.setValue(feature, forKey: Database.Feature)
                    restaurant.setValue(commentNumber, forKey: Database.CommentNumber)
                    restaurant.saveInBackgroundWithBlock { (_, error) in
                        if error != nil {
                            var alert = UIAlertController(title: "Error!", message: Error.PleaseTryAgainLater, preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "Back", style: .Cancel, handler: nil))
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        // save comment
        let content = textView.text
        var comment = PFObject(className: Database.Comment)
        comment[Database.RestaurantName] = restaurantName
        comment[Database.Content] = content
        comment.saveInBackgroundWithBlock { (_, error) in
            if error == nil {
                self.performSegueWithIdentifier("Go Back To Restaurant", sender: nil)
            }
            if error != nil {
                var alert = UIAlertController(title: "Error", message: "Please try again later", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
}