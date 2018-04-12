//
//  Package.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import Foundation

public class Package: NSObject, NSCoding {
    public var id : String?
    public var title : String?
    public var coins : String?
    public var price : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let Notifications_list = Notifications.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Notifications Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Package]
    {
        var models:[Package] = []
        for item in array
        {
            models.append(Package(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let Notifications = Notifications(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Notifications Instance.
     */
    
    required public override init() { }
    
    required public init(coder decoder: NSCoder) {
        id = decoder.decodeObject(forKey:"id") as? String
        title = decoder.decodeObject(forKey:"title") as? String
        coins = decoder.decodeObject(forKey:"coins") as? String
        price = decoder.decodeObject(forKey:"price") as? String
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(title, forKey: "title")
        coder.encode(coins, forKey: "coins")
        coder.encode(price, forKey: "price")
    }
    
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? String
        title = dictionary["title"] as? String
        coins = dictionary["coins"] as? String
        price = dictionary["price"] as? String
    }
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(id, forKey: "id")
        dictionary.setValue(title, forKey: "title")
        dictionary.setValue(coins, forKey: "coins")
        dictionary.setValue(price, forKey: "price")
        
        return dictionary
    }
    
}


