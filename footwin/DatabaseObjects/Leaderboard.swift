//
//  Leaderboard.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/16/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import Foundation

public class Leaderboard: NSObject, NSCoding {
    public var id : String?
    public var user_id : String?
    public var fullname : String?
    public var rank : String?
    public var avatar: String?
    public var coins: String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let Notifications_list = Notifications.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Notifications Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Leaderboard]
    {
        var models:[Leaderboard] = []
        for item in array
        {
            models.append(Leaderboard(dictionary: item as! NSDictionary)!)
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
        user_id = decoder.decodeObject(forKey:"user_id") as? String
        fullname = decoder.decodeObject(forKey:"fullname") as? String
        rank = decoder.decodeObject(forKey:"rank") as? String
        avatar = decoder.decodeObject(forKey:"avatar") as? String
        coins = decoder.decodeObject(forKey:"coins") as? String
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(user_id, forKey: "user_id")
        coder.encode(fullname, forKey: "fullname")
        coder.encode(rank, forKey: "rank")
        coder.encode(avatar, forKey: "avatar")
        coder.encode(coins, forKey: "coins")
    }
    
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? String
        user_id = dictionary["user_id"] as? String
        fullname = dictionary["fullname"] as? String
        rank = dictionary["rank"] as? String
        avatar = dictionary["avatar"] as? String
        coins = dictionary["coins"] as? String
    }
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(id, forKey: "id")
        dictionary.setValue(user_id, forKey: "user_id")
        dictionary.setValue(fullname, forKey: "fullname")
        dictionary.setValue(rank, forKey: "rank")
        dictionary.setValue(avatar, forKey: "avatar")
        dictionary.setValue(coins, forKey: "coins")
        
        return dictionary
    }
    
}
