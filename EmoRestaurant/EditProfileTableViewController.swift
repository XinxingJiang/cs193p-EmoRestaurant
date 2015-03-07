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

    @IBOutlet weak var signatureTextField: UITextField! 
    
    var currentUser: PFUser?
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            updateImage()
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = false
        currentUser = PFUser.currentUser()
        if let signature = currentUser!.valueForKey(AccountViewController.Constants.SignatureKey) as? String {
            signatureTextField.text = signature
        }
        updateImage()
    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        if !signatureTextField.text.isEmpty {
            currentUser!.setValue(signatureTextField.text, forKey: AccountViewController.Constants.SignatureKey)
            if let image = imageView.image {
                let imageData = UIImagePNGRepresentation(imageView.image)
                let imageFile = PFFile(name: NSDate.timeIntervalSinceReferenceDate().description, data: imageData)
                currentUser!.setObject(imageFile, forKey: AccountViewController.Constants.ProfileImageKey)
            }
            spinner.startAnimating()
            currentUser!.saveInBackgroundWithBlock() { (success, error) in
                if error != nil {
                    var alert = UIAlertController(title: "Error!", message: Constants.EditProfileAlertMessage, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Back", style: .Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    self.performSegueWithIdentifier(Constants.SegueIdentifier, sender: nil)
                }
                self.spinner.stopAnimating()
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Constants.SegueIdentifier:
                if let tbvc = segue.destinationViewController as? UITabBarController {
                    tbvc.selectedIndex = 2 // select Account tab view
                }
            default:
                break
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // when click the first row (for picture), pop an action sheet to edit picture
        if indexPath.section == 0 {
            var alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            alert.addAction(UIAlertAction(title: "Take a photo", style: UIAlertActionStyle.Default) { (action) -> Void in
                self.takePhoto()
            })
            alert.addAction(UIAlertAction(title: "Choose an existing photo", style: UIAlertActionStyle.Default) { (action) -> Void in
                self.choosePhoto()
                })
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Photo
    
    private func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let picker = UIImagePickerController()
            picker.sourceType = .Camera
            // if video, check media types
            picker.mediaTypes = [kUTTypeImage]
            picker.delegate = self
            picker.allowsEditing = true
            presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    private func choosePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let picker = UIImagePickerController()
            picker.sourceType = .PhotoLibrary
            // if video, check media types
            picker.mediaTypes = [kUTTypeImage]
            picker.delegate = self
            picker.allowsEditing = true
            presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    // get called when user take a photo or choose a photo
    // save the image to model
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var image = info[UIImagePickerControllerEditedImage] as? UIImage
        if image == nil {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        imageView.image = image
        makeRoomForImage()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func updateImage() {
        if let imageFile = currentUser?.objectForKey(AccountViewController.Constants.ProfileImageKey) as? PFFile {
            let qos = Int(QOS_CLASS_USER_INITIATED.value)
            dispatch_async(dispatch_get_global_queue(qos, 0)) { [weak self] in
                if let imageData = imageFile.getData() {
                    if let image = UIImage(data: imageData) {
                        dispatch_async(dispatch_get_main_queue()) {
                            self?.imageView?.image = image
                            self?.makeRoomForImage()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Constants
    
    private struct Constants {
        static let SegueIdentifier = "Edit Profile Finish"
        static let EditProfileAlertMessage = "Can not save now!"
    }
}

extension EditProfileTableViewController {
    func makeRoomForImage() {
        var extraHeight: CGFloat = 0
        if imageView.image?.aspectRatio > 0 {
            if let width = imageView.superview?.frame.size.width {
                let height = width / imageView.image!.aspectRatio
                extraHeight = height - imageView.frame.height
                imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            }
        } else {
            extraHeight = -imageView.frame.height
            imageView.frame = CGRectZero
        }
        preferredContentSize = CGSize(width: preferredContentSize.width, height: preferredContentSize.height + extraHeight)
        imageView.setNeedsDisplay()
//        imageView.setNeedsLayout()
    }
}

extension UIImage {
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}