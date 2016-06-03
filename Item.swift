//
//  Item.swift
//  Homeowner
//
//  Created by John Cook on 5/30/16.
//  Copyright © 2016 John Cook. All rights reserved.
//

import UIKit

class Item: NSObject, NSCoding {
    
    // MARK: - Variables
    
    var name:           String
    var valueInDollars: Int
    var serialNumber:   String?
    var dateCreated:    NSDate
    let itemKey:        String
    
    // MARK: - Initializers
    
    // designated initializer
    init(name: String, serialNumber: String?, valueInDollars: Int) {
        self.name = name
        self.serialNumber   = serialNumber
        self.valueInDollars = valueInDollars
        self.dateCreated  = NSDate()
        self.itemKey = NSUUID().UUIDString
        
        super.init() // must call super initializer
    }
    
    // convenience init for randomly generated object
    convenience init(random: Bool = false) {
        if (random) {
            let adjectives = ["Fluffy", "Rusty", "Shiny"]
            let nouns      = ["Bear", "Spork", "Mac"]
            
            var idx = arc4random_uniform(UInt32(adjectives.count))
            let randomAdjective = adjectives[Int(idx)]
            
            idx = arc4random_uniform(UInt32(nouns.count))
            let randomNoun = nouns[Int(idx)]
            
            let randomName = "\(randomAdjective) \(randomNoun)"
            let randomValue = Int(arc4random_uniform(100))
            let randomSerialNumber = NSUUID().UUIDString.componentsSeparatedByString("-").first!
            
            // must call designated initializer
            self.init(name: randomName, serialNumber: randomSerialNumber, valueInDollars: randomValue)
        } else {
            self.init(name: "", serialNumber: nil, valueInDollars: 0)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        name           = aDecoder.decodeObjectForKey( "name")         as! String
        dateCreated    = aDecoder.decodeObjectForKey( "dateCreated")  as! NSDate
        itemKey        = aDecoder.decodeObjectForKey( "itemKey")      as! String
        serialNumber   = aDecoder.decodeObjectForKey( "serialNumber") as! String?
        valueInDollars = aDecoder.decodeIntegerForKey("valueInDollars")
        
        super.init()
    }
    
    // MARK: - Functions
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject( name,           forKey: "name") // converts to NSString to save as Object
        aCoder.encodeObject( dateCreated,    forKey: "dateCreated")
        aCoder.encodeObject( itemKey,        forKey: "itemKey")
        aCoder.encodeObject( serialNumber,   forKey: "serialNumber")
        aCoder.encodeInteger(valueInDollars, forKey: "valueInDollars")
    }
}