//
//  PFUserProtocol.swift
//  EmoRestaurant
//
//  Created by Xinxing Jiang on 3/7/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import Foundation
import MobileCoreServices

extension PFUser {
    func setProfileImage(profileImage: UIImage) {
        let imageData = UIImagePNGRepresentation(profileImage)
        let imageFile = PFFile(name: NSDate.timeIntervalSinceReferenceDate().description, data: imageData)
        self.setObject(imageFile, forKey: Database.ProfileImage)
    }
}

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func makeRoomForImage(imageView: UIImageView) {
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
        imageView.setNeedsLayout()
    }
    
    func takePhoto() {
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
    
    func choosePhoto() {
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

}

extension UIImage {
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}

extension UITextView {
    func setStyle(#borderWidth: CGFloat, borderColor: CGColor) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
    }
}

extension UIButton {
    func setStyle(#borderWidth: CGFloat, borderColor: CGColor, backgroundColor: UIColor, tintColor: UIColor) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
    }
}

extension UIStepper {
    func configure(#mininumValue: Double, maximumValue: Double, stepValue: Double, initialValue: Double) {
        self.minimumValue = mininumValue
        self.maximumValue = maximumValue
        self.stepValue = stepValue
        self.value = initialValue
    }
}