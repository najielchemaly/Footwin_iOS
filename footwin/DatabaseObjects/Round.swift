//
//  Round.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/13/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import Foundation

public class Round: NSObject, NSCoding {
    public var id : String?
    public var title : String?
    public var given_amount : String?
    public var minimum_amount : String?
    public var prediction_coins : String?
    public var winning_coins : String?
    public var exact_score_coins : String?
    public var all_in_coins : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let Notifications_list = Notifications.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Notifications Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Round]
    {
        var models:[Round] = []
        for item in array
        {
            models.append(Round(dictionary: item as! NSDictionary)!)
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
    
    public init(id: String, title: String) {
        self.id = id
        self.title = title
    }
    
    required public override init() { }
    
    required public init(coder decoder: NSCoder) {
        id = decoder.decodeObject(forKey:"id") as? String
        title = decoder.decodeObject(forKey:"title") as? String
        given_amount = decoder.decodeObject(forKey:"given_amount") as? String
        minimum_amount = decoder.decodeObject(forKey:"minimum_amount") as? String
        prediction_coins = decoder.decodeObject(forKey:"prediction_coins") as? String
        winning_coins = decoder.decodeObject(forKey:"winning_coins") as? String
        exact_score_coins = decoder.decodeObject(forKey:"exact_score_coins") as? String
        all_in_coins = decoder.decodeObject(forKey:"all_in_coins") as? String
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(title, forKey: "title")
        coder.encode(given_amount, forKey: "given_amount")
        coder.encode(minimum_amount, forKey: "minimum_amount")
        coder.encode(prediction_coins, forKey: "prediction_coins")
        coder.encode(winning_coins, forKey: "winning_coins")
        coder.encode(exact_score_coins, forKey: "exact_score_coins")
        coder.encode(all_in_coins, forKey: "all_in_coins")
    }
    
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? String
        title = dictionary["title"] as? String
        given_amount = dictionary["given_amount"] as? String
        minimum_amount = dictionary["minimum_amount"] as? String
        prediction_coins = dictionary["prediction_coins"] as? String
        winning_coins = dictionary["winning_coins"] as? String
        exact_score_coins = dictionary["exact_score_coins"] as? String
        all_in_coins = dictionary["all_in_coins"] as? String
    }
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(id, forKey: "id")
        dictionary.setValue(title, forKey: "title")
        dictionary.setValue(given_amount, forKey: "given_amount")
        dictionary.setValue(minimum_amount, forKey: "minimum_amount")
        dictionary.setValue(prediction_coins, forKey: "prediction_coins")
        dictionary.setValue(winning_coins, forKey: "winning_coins")
        dictionary.setValue(exact_score_coins, forKey: "exact_score_coins")
        dictionary.setValue(all_in_coins, forKey: "all_in_coins")
        
        return dictionary
    }
    
}
