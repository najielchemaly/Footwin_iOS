//
//  AdminAdminUser.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/21/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import Foundation

public class AdminUser: User {
    public var predictions : Array<Prediction>?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let Notifications_list = Notifications.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Notifications Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [AdminUser]
    {
        var models:[AdminUser] = []
        for item in array
        {
            models.append(AdminUser(dictionary: item as! NSDictionary)!)
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
    
    public required init() {
        super.init()
    }
    
    public required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        predictions = decoder.decodeObject(forKey:"predictions") as? Array<Prediction>
    }
    
    public override func encode(with coder: NSCoder) {
        coder.encode(predictions, forKey: "predictions")
    }
    
    public required init?(dictionary: NSDictionary) {
        super.init(dictionary: dictionary)
        
        if (dictionary["predictions"] != nil) {
            predictions = Prediction.modelsFromDictionaryArray(array: dictionary["predictions"] as! NSArray)
        }
    }
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public override func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        return dictionary
    }
    
}
