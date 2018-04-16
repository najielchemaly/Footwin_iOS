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
    public var match_id : String?
    public var winning_score : String?
    public var losing_score : String?
    public var status : String?
    public var home_flag : String?
    public var away_flag : String?
    public var home_name : String?
    public var away_name : String?
    public var selected_team : String?
    
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
        winning_score = decoder.decodeObject(forKey:"winning_score") as? String
        losing_score = decoder.decodeObject(forKey:"losing_score") as? String
        status = decoder.decodeObject(forKey:"status") as? String
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(match_id, forKey: "match_id")
        coder.encode(winning_score, forKey: "winning_score")
        coder.encode(losing_score, forKey: "losing_score")
        coder.encode(status, forKey: "status")
    }
    
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? String
        match_id = dictionary["match_id"] as? String
        winning_score = dictionary["winning_score"] as? String
        losing_score = dictionary["losing_score"] as? String
        status = dictionary["status"] as? String
    }
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(id, forKey: "id")
        dictionary.setValue(match_id, forKey: "match_id")
        dictionary.setValue(winning_score, forKey: "winning_score")
        dictionary.setValue(losing_score, forKey: "losing_score")
        dictionary.setValue(status, forKey: "status")
        
        return dictionary
    }
    
}
