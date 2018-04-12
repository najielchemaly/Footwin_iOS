//
//  Nes.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import Foundation

public class News: NSObject, NSCoding {
    public var id : String?
    public var title : String?
    public var desc : String?
    public var img_thumb : String?
    public var img_url : String?
    public var date : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let Notifications_list = Notifications.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Notifications Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [News]
    {
        var models:[News] = []
        for item in array
        {
            models.append(News(dictionary: item as! NSDictionary)!)
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
        img_thumb = decoder.decodeObject(forKey:"img_thumb") as? String
        img_url = decoder.decodeObject(forKey:"img_url") as? String
        date = decoder.decodeObject(forKey:"date") as? String
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(title, forKey: "title")
        coder.encode(desc, forKey: "description")
        coder.encode(img_thumb, forKey: "img_thumb")
        coder.encode(img_url, forKey: "img_url")
        coder.encode(date, forKey: "date")
    }
    
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? String
        title = dictionary["title"] as? String
        desc = dictionary["description"] as? String
        img_thumb = dictionary["img_thumb"] as? String
        img_url = dictionary["img_url"] as? String
        date = dictionary["date"] as? String
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
        dictionary.setValue(img_thumb, forKey: "img_thumb")
        dictionary.setValue(img_url, forKey: "img_url")
        dictionary.setValue(date, forKey: "date")
        
        return dictionary
    }
    
}
