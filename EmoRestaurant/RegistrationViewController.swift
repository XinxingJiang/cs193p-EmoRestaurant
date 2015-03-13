//
//  RegistrationViewController.swift
//  EmoRestaurant
//
//  Created by YUE on 2/3/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit
import MobileCoreServices

class RegistrationViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    
    @IBOutlet weak var uploadProfileImageButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // move cursor to username field automatically
        usernameTextField.becomeFirstResponder()
        // make register button unclickable
        uploadProfileImageButton.setStyle(borderWidth: 1.0, borderColor: UIColor.blueColor().CGColor)
        registerButton.setStyle(borderWidth: 1.0, borderColor: UIColor.blueColor().CGColor)
        registerButton.enabled = false
        navigationController?.navigationBarHidden = false
    }
    
    // MARK: - Profile Image
    
    // model for profile image
    var profileImage: UIImage?

    @IBAction func uploadProfileImage() {
        var alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "Take a photo", style: UIAlertActionStyle.Default) { (action) in
            self.takePhoto()
            })
        alert.addAction(UIAlertAction(title: "Choose an existing photo", style: UIAlertActionStyle.Default) { (action) in
            self.choosePhoto()
            })
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
        
    // MARK: - Image Picker Delegate
    
    // get called when user take a photo or choose a photo
    // save the image to model
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var image = info[UIImagePickerControllerEditedImage] as? UIImage
        if image == nil {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        profileImage = image!
        if picker.sourceType == UIImagePickerControllerSourceType.Camera {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Register
    
    @IBAction func register() {
        spinner.startAnimating()
        let username = usernameTextField.text
        let password = passwordTextField.text
        let user = PFUser()
        user.username = username
        user.password = password
        if profileImage != nil {
            user.setProfileImage(profileImage!)
        }
        user.signUpInBackgroundWithBlock { (_, error) in
            // for security reason, the user needs to input password in login page again
            // for convience, username will be filled
            if error == nil {
                self.performSegueWithIdentifier(Constants.SegueIdentifier, sender: self.registerButton)
            } else {
                var errorMessage: String
                switch error.code {
                case Error.NetworkErrorCode:
                    errorMessage = Error.NetworkErrorMessage
                case Error.UsernameExistErrorCode:
                    errorMessage = Error.UsernameExistErrorMessage
                default:
                    errorMessage = Error.UnknownErrorMessage
                }
                
                var alert = UIAlertController(title: "Error!", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Back", style: .Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.spinner.stopAnimating()
        }
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Constants.SegueIdentifier:
                if let lvc = segue.destinationViewController as? LoginViewController {
                    lvc.username = usernameTextField.text
                }
            default: break
            }
        }
    }
    
    // MARK: - Constants
    
    private struct Constants {
        static let SegueIdentifier = "Register Finish"
    }
    
    // MARK: Text Field Delegate
    
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