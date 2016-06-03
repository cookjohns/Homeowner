//
//  DetailViewController.swift
//  Homeowner
//
//  Created by John Cook on 5/30/16.
//  Copyright © 2016 John Cook. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate,
    UIImagePickerControllerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet var nameField: TextField!//UITextField!
    @IBOutlet var serialField: TextField!//UITextField!
    @IBOutlet var valueField: TextField!//UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    // MARK: - Variables
    
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    var imageStore: ImageStore!
    
    let numberFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        return formatter
    }()
    
    // MARK: - Actions
    
    @IBAction func backgroundTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func takePicture(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        
        // if device has camera, take picture (else pick from photo library)
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = .Camera
        } else {
            imagePicker.sourceType = .PhotoLibrary
        }
        
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        // put imagine picker on screen
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func removePicture(sender: UIBarButtonItem) {
        // pop up alert
        let title = "Delete image?"
        let message = "Are you sure you want to delete this image?"
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
        
        // alert actions
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        ac.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: {
            (action) -> Void in
            
            // set blank image and remove item from imageStore
            self.imageView.image = nil
            self.imageStore.deleteImageForKey(self.item.itemKey)
        })
        ac.addAction(deleteAction)
        // present the alert controller
        presentViewController(ac, animated: true, completion: nil)
    }
    
    // MARK: - Functions
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
        [String: AnyObject]) {
        // get picked image from info dictionary
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // store image in imageStore with generated UUID
        imageStore.setImage(image, forKey: item.itemKey)
        
        // put ^ image on screen in the image view
        imageView.image = image
        
        // take picker off screen (must call to dismiss)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        nameField.text   = item.name
        serialField.text = item.serialNumber
        valueField.text  = numberFormatter.stringFromNumber(item.valueInDollars)
        dateLabel.text   = dateFormatter.stringFromDate(item.dateCreated)
        
        // get item key
        let key = item.itemKey
        
        // if item has associated image, display it in imageView
        let imageToDisplay = imageStore.imageForKey(key)
        imageView.image    = imageToDisplay
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // clear first responder
        view.endEditing(true)
        
        // "save" (for view controller) the changes to item
        item.name = nameField.text ?? ""
        item.serialNumber = serialField.text
        
        if let valueText = valueField.text,
            value = numberFormatter.numberFromString(valueText) {
            item.valueInDollars = value.integerValue
        } else {
            item.valueInDollars = 0
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showDatePicker") {
            let datePickerViewController = segue.destinationViewController as! DatePickerViewController
            datePickerViewController.date = item.dateCreated
            datePickerViewController.navigationItem.title = "Change Date"
        }
    }
}