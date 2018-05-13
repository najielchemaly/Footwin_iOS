//
//  Prediction.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import Foundation

public class Prediction: NSObject, NSCoding {
    public var id : String?
    public var user_id : String?
    public var match_id : String?
    public var winning_team : String?
    public var status : String?
    public var selected_team : String?
    public var home_id : String?
    public var home_flag : String?
    public var home_name : String?
    public var home_score : String?
    public var away_id : String?
    public var away_flag : String?
    public var away_name : String?
    public var away_score : String?
    public var title : String?
    public var desc : String?
    public var date : String?
    public var timer: Timer!
    public var winning_coins : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let Predictions_list = Predictions.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Predictions Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Prediction]
    {
        var models:[Prediction] = []
        for item in array
        {
            models.append(Prediction(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let Predictions = Predictions(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Predictions Instance.
     */
    
    required public override init() { }
    
    required public init(coder decoder: NSCoder) {
        id = decoder.decodeObject(forKey:"id") as? String
        match_id = decoder.decodeObject(forKey:"match_id") as? String
        home_id = decoder.decodeObject(forKey:"home_id") as? String
        home_score = decoder.decodeObject(forKey:"home_score") as? String
        home_name = decoder.decodeObject(forKey:"home_name") as? String
        home_flag = decoder.decodeObject(forKey:"home_flag") as? String
        away_score = decoder.decodeObject(forKey:"away_score") as? String
        away_name = decoder.decodeObject(forKey:"away_name") as? String
        away_id = decoder.decodeObject(forKey:"away_id") as? String
        away_flag = decoder.decodeObject(forKey:"away_flag") as? String
        status = decoder.decodeObject(forKey:"status") as? String
        winning_team = decoder.decodeObject(forKey:"winning_team") as? String
        selected_team = decoder.decodeObject(forKey:"selected_team") as? String
        title = decoder.decodeObject(forKey:"title") as? String
        desc = decoder.decodeObject(forKey:"description") as? String
        date = decoder.decodeObject(forKey:"date") as? String
        winning_coins = decoder.decodeObject(forKey:"winning_coins") as? String
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(match_id, forKey: "match_id")
        coder.encode(home_id, forKey: "home_id")
        coder.encode(home_score, forKey: "home_score")
        coder.encode(home_name, forKey: "home_name")
        coder.encode(home_flag, forKey: "home_flag")
        coder.encode(away_id, forKey: "away_id")
        coder.encode(away_score, forKey: "away_score")
        coder.encode(away_name, forKey: "away_name")
        coder.encode(away_flag, forKey: "away_flag")
        coder.encode(status, forKey: "status")
        coder.encode(winning_team, forKey: "winning_team")
        coder.encode(selected_team, forKey: "selected_team")
        coder.encode(title, forKey: "title")
        coder.encode(desc, forKey: "description")
        coder.encode(date, forKey: "date")
        coder.encode(winning_coins, forKey: "winning_coins")
    }
    
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? String
        match_id = dictionary["match_id"] as? String
        home_id = dictionary["home_id"] as? String
        home_score = dictionary["home_score"] as? String
        home_name = dictionary["home_name"] as? String
        home_flag = dictionary["home_flag"] as? String
        away_id = dictionary["away_id"] as? String
        away_score = dictionary["away_score"] as? String
        away_name = dictionary["away_name"] as? String
        away_flag = dictionary["away_flag"] as? String
        status = dictionary["status"] as? String
        winning_team = dictionary["winning_team"] as? String
        selected_team = dictionary["selected_team"] as? String
        title = dictionary["title"] as? String
        desc = dictionary["description"] as? String
        date = dictionary["date"] as? String
        winning_coins = dictionary["winning_coins"] as? String
    }
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(id, forKey: "id")
        dictionary.setValue(match_id, forKey: "match_id")
        dictionary.setValue(home_id, forKey: "home_id")
        dictionary.setValue(home_score, forKey: "home_score")
        dictionary.setValue(home_name, forKey: "home_name")
        dictionary.setValue(home_flag, forKey: "home_flag")
        dictionary.setValue(away_id, forKey: "away_id")
        dictionary.setValue(away_score, forKey: "away_score")
        dictionary.setValue(away_name, forKey: "away_name")
        dictionary.setValue(away_flag, forKey: "away_flag")
        dictionary.setValue(status, forKey: "status")
        dictionary.setValue(winning_team, forKey: "winning_team")
        dictionary.setValue(selected_team, forKey: "selected_team")
        dictionary.setValue(title, forKey: "title")
        dictionary.setValue(desc, forKey: "description")
        dictionary.setValue(date, forKey: "date")
        dictionary.setValue(winning_coins, forKey: "winning_coins")
        
        return dictionary
    }
    
}
