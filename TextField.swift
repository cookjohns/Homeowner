//
//  textField.swift
//  Homeowner
//
//  Created by John Cook on 6/1/16.
//  Copyright © 2016 John Cook. All rights reserved.
//

import UIKit

class TextField: UITextField {
    
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = UIColor.orangeColor().CGColor
        self.layer.borderWidth = 0.5
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.borderWidth = 0.1
        return true
    }
}