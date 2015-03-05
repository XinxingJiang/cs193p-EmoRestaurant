//
//  RegistrationViewController.swift
//  EmoRestaurant
//
//  Created by YUE on 2/3/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField! {
        didSet {
            usernameTextField.delegate = self
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.delegate = self
        }
    }
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // move cursor to username field automatically
        usernameTextField.becomeFirstResponder()
        // make register button unclickable
        registerButton.enabled = false
        registerButton.layer.borderWidth = 1.0
        registerButton.layer.borderColor = UIColor.blueColor().CGColor
        navigationController?.navigationBarHidden = false
    }

    @IBAction func register() {
        let username = usernameTextField.text
        let password = passwordTextField.text
        let user = PFUser()
        user.username = username
        user.password = password
        user.signUpInBackgroundWithBlock { (success, error) in
            // for security reason, the user needs to input password in login page again
            // for convience, username will be filled
            if success {
                self.performSegueWithIdentifier(Constants.SegueIdentifier, sender: self.registerButton)
            } else {
                var alert = UIAlertController(title: "Error!", message: Constants.RegisterAlertMessage, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Back", style: .Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Constants.SegueIdentifier:
                if let navCon = segue.destinationViewController as? UINavigationController {
                    if let lvc = navCon.visibleViewController as? LoginViewController {
                        lvc.username = usernameTextField.text
                    }
                }
            default: break
            }
        }
    }
    
    private struct Constants {
        static let SegueIdentifier = "Register Finish"
        static let RegisterAlertMessage = "username already taken"
    }
    
    // when click return at username textfield, move cursor to password textfield; when click return at password field, hide keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            if registerButton.enabled {
                register()
            }
        }
        return true
    }
    
    // The text field calls this method BEFORE the user types a new character in the text field or deletes an existing character.
    // determine whether register button is clickable
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let textAfterEdit = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        if textAfterEdit.isEmpty {
            registerButton.enabled = false
        } else if textField == usernameTextField {
            registerButton.enabled = !passwordTextField.text.isEmpty
        } else if textField == passwordTextField {
            registerButton.enabled = !usernameTextField.text.isEmpty
        }
        return true
    }
}
