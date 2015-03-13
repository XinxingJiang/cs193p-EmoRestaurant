//
//  EditProfileTableViewController.swift
//  EmoRestaurant
//
//  Created by Xinxing Jiang on 3/5/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit
import MobileCoreServices

class EditProfileTableViewController: UITableViewController, UITextFieldDelegate, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var currentUser: PFUser?
    var profileImageChanged: Bool = false
    @IBOutlet weak var signatureTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            loadProfileImage()
        }
    }
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // MARK: - View Controller View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = false
        currentUser = PFUser.currentUser()
        if let signature = currentUser!.valueForKey(Database.Signature) as? String {
            signatureTextField.text = signature
        }
        loadProfileImage()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Save
    
    @IBAction func save(sender: UIBarButtonItem) {
        if !signatureTextField.text.isEmpty {
            currentUser!.setValue(signatureTextField.text, forKey: Database.Signature)
        }
        if let image = imageView.image {
            if profileImageChanged {
                currentUser!.setProfileImage(image)
            }
        }
        spinner.startAnimating()
        currentUser!.saveInBackgroundWithBlock() { (_, error) in
            if error != nil {
                var alert = UIAlertController(title: "Error!", message: Constants.EditProfileAlertMessage, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Back", style: .Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                self.performSegueWithIdentifier(StoryBoard.GoBackToAccountSegueIdentifier, sender: nil)
            }
            self.spinner.stopAnimating()
        }
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // when click the first row (for picture), pop an action sheet to edit picture
        if indexPath.section == 0 {
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
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Profile Image
    
    private func loadProfileImage() {
        if let imageFile = currentUser?.objectForKey(Database.ProfileImage) as? PFFile {
            let qos = Int(QOS_CLASS_USER_INITIATED.value)
            dispatch_async(dispatch_get_global_queue(qos, 0)) { [weak self] in
                if let imageData = imageFile.getData() {
                    if let image = UIImage(data: imageData) {
                        dispatch_async(dispatch_get_main_queue()) {
                            self?.imageView?.image = image
                            self?.makeRoomForImage(self!.imageView)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Image Picker Delegate
    
    // get called when user take a photo or choose a photo
    // save the image to model
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var image = info[UIImagePickerControllerEditedImage] as? UIImage
        if image == nil {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        imageView.image = image
        profileImageChanged = true
        makeRoomForImage(imageView)
        if picker.sourceType == UIImagePickerControllerSourceType.Camera {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Constants
    
    private struct Constants {
        static let EditProfileAlertMessage = "Can not save now!"
    }
}