//
//  Team.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import Foundation

public class Team: NSObject, NSCoding {
    public var id : String?
    public var name : String?
    public var flag : String?
    public var type : String?
    public var group : String?
    public var is_selected : Bool?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let Teams_list = Teams.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Teams Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Team]
    {
        var models:[Team] = []
        for item in array
        {
            models.append(Team(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let Teams = Teams(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Teams Instance.
     */
    
    required public override init() { }
    
    required public init(coder decoder: NSCoder) {
        id = decoder.decodeObject(forKey:"id") as? String
        name = decoder.decodeObject(forKey:"name") as? String
        flag = decoder.decodeObject(forKey:"flag") as? String
        type = decoder.decodeObject(forKey:"type") as? String
        group = decoder.decodeObject(forKey:"group") as? String
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(name, forKey: "name")
        coder.encode(flag, forKey: "flag")
        coder.encode(type, forKey: "type")
        coder.encode(group, forKey: "group")
    }
    
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? String
        name = dictionary["name"] as? String
        flag = dictionary["flag"] as? String
        type = dictionary["type"] as? String
        group = dictionary["group"] as? String
    }
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(id, forKey: "id")
        dictionary.setValue(name, forKey: "name")
        dictionary.setValue(flag, forKey: "flag")
        dictionary.setValue(type, forKey: "type")
        dictionary.setValue(group, forKey: "group")
        
        return dictionary
    }
    
}
