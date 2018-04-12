//
//  _Country.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import Foundation

public class _Country: NSObject, NSCoding {
    public var id : String?
    public var name : String?
    public var code : String?
    public var dialing_code : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let Notifications_list = Notifications.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Notifications Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [_Country]
    {
        var models:[_Country] = []
        for item in array
        {
            models.append(_Country(dictionary: item as! NSDictionary)!)
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
        name = decoder.decodeObject(forKey:"name") as? String
        code = decoder.decodeObject(forKey:"code") as? String
        dialing_code = decoder.decodeObject(forKey:"dialing_code") as? String
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(name, forKey: "name")
        coder.encode(code, forKey: "code")
        coder.encode(dialing_code, forKey: "dialing_code")
    }
    
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? String
        name = dictionary["name"] as? String
        code = dictionary["code"] as? String
        dialing_code = dictionary["dialing_code"] as? String
    }
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(id, forKey: "id")
        dictionary.setValue(name, forKey: "name")
        dictionary.setValue(code, forKey: "code")
        dictionary.setValue(dialing_code, forKey: "dialing_code")
        
        return dictionary
    }
    
}



