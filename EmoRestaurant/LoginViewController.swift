//
//  LoginViewController.swift
//  EmoRestaurant
//
//  Created by YUE on 2/3/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var autoLogin = true
    
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
    
    // model for segue from register view
    var username: String?
    
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // move cursor to proper field automatically
        if username == nil {
            usernameTextField.becomeFirstResponder()
        } else {
            usernameTextField.text = username
            passwordTextField.becomeFirstResponder()
        }
        // make login button unclickable
        loginButton.enabled = false
        loginButton.setStyle(borderWidth: 1.0, borderColor: UIColor.blueColor().CGColor)
        navigationController?.navigationBarHidden = true
        
        // test only
        if autoLogin {
            usernameTextField.text = "123"
            passwordTextField.text = "123"
            login()
        }
    }
    
    // MARL: - Login
    
    @IBAction func login() {
        let username = usernameTextField.text
        let password = passwordTextField.text
        PFUser.logInWithUsernameInBackground(username, password: password) { (user, error) in
            if error == nil {
                self.performSegueWithIdentifier(Constants.SegueIdentifier, sender: nil)
            } else {
                println(error.code)
                var errorMessage: String
                switch error.code {
                case Error.NetworkErrorCode:
                    errorMessage = Error.NetworkErrorMessage
                case Error.InvalidLoginParameterErrorCode:
                    errorMessage = Error.InvalidLoginParameterErrorMessage
                default:
                    errorMessage = Error.UnknownErrorMessage
                }
                var alert = UIAlertController(title: "Error!", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Back", style: .Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Constants
    
    private struct Constants {
        static let SegueIdentifier = "Login Finish"
    }
    
    // MARK: - Text Field Delegate
    
    // when click return at username textfield, move cursor to password textfield; when click return at password field, hide keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            if loginButton.enabled {
                login()
            }
        }
        return true
    }
    
    // The text field calls this method BEFORE the user types a new character in the text field or deletes an existing character.
    // determine whether login button is clickable
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let textAfterEdit = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        if textAfterEdit.isEmpty {
            loginButton.enabled = false
        } else if textField == usernameTextField {
            loginButton.enabled = !passwordTextField.text.isEmpty
        } else if textField == passwordTextField {
            loginButton.enabled = !usernameTextField.text.isEmpty
        }
        return true
    }
}
