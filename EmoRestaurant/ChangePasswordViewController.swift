//
//  ChangePasswordViewController.swift
//  EmoRestaurant
//
//  Created by Xinxing Jiang on 3/7/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {

    var currentUser: PFUser?
    
    @IBOutlet weak var oldPasswordTextField: UITextField! {
        didSet {
            oldPasswordTextField.delegate = self
        }
    }
    @IBOutlet weak var newPasswordTextField: UITextField! {
        didSet {
            newPasswordTextField.delegate = self
        }
    }
    @IBOutlet weak var confirmedNewPasswordTextField: UITextField! {
        didSet {
            confirmedNewPasswordTextField.delegate = self
        }
    }
    
    // MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = false
        oldPasswordTextField.becomeFirstResponder()
        currentUser = PFUser.currentUser()
    }
    
    // MARK: - Save
    
    @IBAction func save() {
        let oldPassword = oldPasswordTextField.text
        let newPassword = newPasswordTextField.text
        let confirmedNewPassword = confirmedNewPasswordTextField.text
        if newPassword == "" {
            var alert = UIAlertController(title: "Error!", message: "New password can not be empty.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Back", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            self.reset()
        } else if newPassword != confirmedNewPassword {
            var alert = UIAlertController(title: "Error!", message: "Passwords do not match.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Back", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            self.reset()
        } else {
            PFUser.logInWithUsernameInBackground(currentUser?.username, password: oldPassword) { (_, error) in
                if error == nil {
                    self.currentUser?.setValue(newPassword, forKey: "Password")
                    self.currentUser?.saveInBackgroundWithBlock() { (_, error) in
                        // success
                        if error == nil {
                            self.performSegueWithIdentifier(StoryBoard.GoBackToAccountSegueIdentifier, sender: nil) // success
                        } else {
                            var alert = UIAlertController(title: "Error!", message: Error.NetworkErrorMessage, preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "Back", style: .Cancel, handler: nil))
                            self.presentViewController(alert, animated: true, completion: nil)
                            self.reset()
                        }
                    }
                } else {
                    var alert = UIAlertController(title: "Error!", message: "The password you gave is incorrect.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Back", style: .Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    self.reset()
                }
            }
        }
    }
    
    // MARK: - Reset
    
    // reset three text fields, set first text field as first responder
    private func reset() {
        self.oldPasswordTextField.text = ""
        self.newPasswordTextField.text = ""
        self.confirmedNewPasswordTextField.text = ""
        self.oldPasswordTextField.becomeFirstResponder()
    }
        
    // MARK: Text Field Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == oldPasswordTextField {
            newPasswordTextField.becomeFirstResponder()
        } else if textField == newPasswordTextField {
            confirmedNewPasswordTextField.becomeFirstResponder()
        } else if textField == confirmedNewPasswordTextField {
            save()
        }
        return true
    }
}
