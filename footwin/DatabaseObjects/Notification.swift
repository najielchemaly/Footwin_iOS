//
//  Notification.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import Foundation
import UIKit

public class Notification: NSObject, NSCoding {
    public var id : String?
    public var title : String?
    public var desc : String?
    public var date : String?
    public var type : String?
    public var match_id : String?
    public var row_height: CGFloat?
    public var is_read: Bool?
    public var is_read_updated: Bool?
    public var home_name : String?
    public var home_flag : String?
    public var home_score : String?
    public var away_name : String?
    public var away_flag : String?
    public var away_score : String?
    
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
        is_read = decoder.decodeObject(forKey:"is_read") as? Bool
        home_name = decoder.decodeObject(forKey:"home_name") as? String
        home_flag = decoder.decodeObject(forKey:"home_flag") as? String
        home_score = decoder.decodeObject(forKey:"home_score") as? String
        away_name = decoder.decodeObject(forKey:"away_name") as? String
        away_flag = decoder.decodeObject(forKey:"away_flag") as? String
        away_score = decoder.decodeObject(forKey:"away_score") as? String
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(title, forKey: "title")
        coder.encode(desc, forKey: "description")
        coder.encode(date, forKey: "date")
        coder.encode(type, forKey: "type")
        coder.encode(match_id, forKey: "match_id")
        coder.encode(is_read, forKey: "is_read")
        coder.encode(home_name, forKey: "home_name")
        coder.encode(home_flag, forKey: "home_flag")
        coder.encode(home_score, forKey: "home_score")
        coder.encode(away_name, forKey: "away_name")
        coder.encode(away_flag, forKey: "away_flag")
        coder.encode(away_score, forKey: "away_score")
    }
    
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? String
        title = dictionary["title"] as? String
        desc = dictionary["description"] as? String
        date = dictionary["date"] as? String
        type = dictionary["type"] as? String
        match_id = dictionary["match_id"] as? String
        if let isRead = dictionary["is_read"] as? String {
            if isRead == "1" {
                is_read = true
            } else {
                is_read = false
            }
        }
        home_name = dictionary["home_name"] as? String
        home_flag = dictionary["home_flag"] as? String
        home_score = dictionary["home_score"] as? String
        away_name = dictionary["away_name"] as? String
        away_flag = dictionary["away_flag"] as? String
        away_score = dictionary["away_score"] as? String
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
        dictionary.setValue(is_read, forKey: "is_read")
        dictionary.setValue(home_name, forKey: "home_name")
        dictionary.setValue(home_flag, forKey: "home_flag")
        dictionary.setValue(home_score, forKey: "home_score")
        dictionary.setValue(away_name, forKey: "away_name")
        dictionary.setValue(away_flag, forKey: "away_flag")
        dictionary.setValue(away_score, forKey: "away_score")
        
        return dictionary
    }
    
}
