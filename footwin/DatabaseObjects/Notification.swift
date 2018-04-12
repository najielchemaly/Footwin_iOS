//
//  Notification.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import Foundation

public class Notification: NSObject, NSCoding {
    public var id : String?
    public var title : String?
    public var desc : String?
    public var date : String?
    public var type : String?
    public var match_id : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let Notifications_list = Notifications.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Notifications Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Notification]
    {
        var models:[Notification] = []
        for item in array
        {
            models.append(Notification(dictionary: item as! NSDictionary)!)
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
        desc = decoder.decodeObject(forKey:"description") as? String
        date = decoder.decodeObject(forKey:"date") as? String
        type = decoder.decodeObject(forKey:"type") as? String
        match_id = decoder.decodeObject(forKey:"match_id") as? String
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(title, forKey: "title")
        coder.encode(desc, forKey: "description")
        coder.encode(date, forKey: "date")
        coder.encode(type, forKey: "type")
        coder.encode(match_id, forKey: "match_id")
    }
    
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? String
        title = dictionary["title"] as? String
        desc = dictionary["description"] as? String
        date = dictionary["date"] as? String
        type = dictionary["type"] as? String
        match_id = dictionary["match_id"] as? String
    }
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(id, forKey: "id")
        dictionary.setValue(title, forKey: "title")
        dictionary.setValue(desc, forKey: "description")
        dictionary.setValue(date, forKey: "date")
        dictionary.setValue("type", forKey: "type")
        dictionary.setValue(match_id, forKey: "match_id")
        
        return dictionary
    }
    
}
