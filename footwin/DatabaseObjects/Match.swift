//
//  Match.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import Foundation

public class Match: NSObject, NSCoding {
    public var id : String?
    public var home_id : String?
    public var away_id : String?
    public var date : String?
    public var home_score : String?
    public var away_score : String?
    public var round : String?
    public var home_name : String?
    public var home_flag : String?
    public var away_name : String?
    public var away_flag : String?
    public var prediction_coins : String?
    public var winning_coins : String?
    public var exact_score_coins : String?
    public var selected_team: String?
    public var confirmed: Bool?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let Notifications_list = Notifications.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Notifications Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Match]
    {
        var models:[Match] = []
        for item in array
        {
            models.append(Match(dictionary: item as! NSDictionary)!)
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
        home_id = decoder.decodeObject(forKey:"home_id") as? String
        away_id = decoder.decodeObject(forKey:"away_id") as? String
        date = decoder.decodeObject(forKey:"date") as? String
        home_score = decoder.decodeObject(forKey:"home_score") as? String
        away_score = decoder.decodeObject(forKey:"away_score") as? String
        round = decoder.decodeObject(forKey:"round") as? String
        home_name = decoder.decodeObject(forKey:"home_name") as? String
        home_flag = decoder.decodeObject(forKey:"home_flag") as? String
        away_name = decoder.decodeObject(forKey:"away_name") as? String
        away_flag = decoder.decodeObject(forKey:"away_flag") as? String
        prediction_coins = decoder.decodeObject(forKey:"prediction_coins") as? String
        winning_coins = decoder.decodeObject(forKey:"winning_coins") as? String
        exact_score_coins = decoder.decodeObject(forKey:"exact_score_coins") as? String
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(id, forKey:"home_id")
        coder.encode(id, forKey:"away_id")
        coder.encode(id, forKey:"date")
        coder.encode(id, forKey:"home_score")
        coder.encode(id, forKey:"away_score")
        coder.encode(id, forKey:"round")
        coder.encode(id, forKey:"home_name")
        coder.encode(id, forKey:"home_flag")
        coder.encode(id, forKey:"away_name")
        coder.encode(id, forKey:"away_flag")
        coder.encode(id, forKey:"prediction_coins")
        coder.encode(id, forKey:"winning_coins")
        coder.encode(id, forKey:"exact_score_coins")
    }
    
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? String
        home_id = dictionary["home_id"] as? String
        away_id = dictionary["away_id"] as? String
        date = dictionary["date"] as? String
        home_score = dictionary["home_score"] as? String
        away_score = dictionary["away_score"] as? String
        round = dictionary["round"] as? String
        home_name = dictionary["home_name"] as? String
        home_flag = dictionary["home_flag"] as? String
        away_name = dictionary["away_name"] as? String
        away_flag = dictionary["away_flag"] as? String
        prediction_coins = dictionary["prediction_coins"] as? String
        winning_coins = dictionary["winning_coins"] as? String
        exact_score_coins = dictionary["exact_score_coins"] as? String
    }
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(id, forKey: "id")
        dictionary.setValue(id, forKey:"home_id")
        dictionary.setValue(id, forKey:"away_id")
        dictionary.setValue(id, forKey:"date")
        dictionary.setValue(id, forKey:"home_score")
        dictionary.setValue(id, forKey:"away_score")
        dictionary.setValue(id, forKey:"round")
        dictionary.setValue(id, forKey:"home_name")
        dictionary.setValue(id, forKey:"home_flag")
        dictionary.setValue(id, forKey:"away_name")
        dictionary.setValue(id, forKey:"away_flag")
        dictionary.setValue(id, forKey:"prediction_coins")
        dictionary.setValue(id, forKey:"winning_coins")
        dictionary.setValue(id, forKey:"exact_score_coins")
        
        return dictionary
    }
    
}
