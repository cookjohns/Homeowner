//
//  ItemCell.swift
//  Homeowner
//
//  Created by John Cook on 5/30/16.
//  Copyright © 2016 John Cook. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    @IBOutlet var nameLabel:         UILabel!
    @IBOutlet var serialNumberLabel: UILabel!
    @IBOutlet var valueLabel:        UILabel!
    
    func updateLabels() {
        let bodyFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        nameLabel.font  = bodyFont
        valueLabel.font = bodyFont
        let caption1Font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        serialNumberLabel.font = caption1Font
    }
}