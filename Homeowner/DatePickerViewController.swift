//
//  DatePickerViewController.swift
//  Homeowner
//
//  Created by John Cook on 6/1/16.
//  Copyright © 2016 John Cook. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var date: NSDate!
    var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(DatePickerViewController.acceptDate))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func acceptDate() {
        if let currentVCIndex = navigationController?.viewControllers.indexOf(self) {
            if let detailViewController = navigationController?.viewControllers[currentVCIndex-1] as? DetailViewController {
                detailViewController.item.dateCreated = datePicker.date
            }
        }
        navigationController?.popViewControllerAnimated(true)
    }
}