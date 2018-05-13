//
//  User.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import Foundation
import UIKit

public class User: NSObject, NSCoding {
    public var id : String?
    public var fullname : String?
    public var username : String?
    public var email : String?
    public var password : String?
    public var phone : String?
    public var phone_code : String?
    public var gender: String?
    public var country: String?
    public var facebook_id : String?
    public var facebook_token : String?
    public var google_id : String?
    public var google_token : String?
    public var avatar: String?
    public var favorite_team : String?
    public var firebase_token: String?
    public var is_verified: Bool?
    public var coins: String?
    public var winning_coins: String?
    public var rank: String?
    public var expected_winning_team: String?
    public var is_loggedIn: Bool?
    public var image: UIImage?
    public var role: String?
    public var access_token: String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let Notifications_list = Notifications.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Notifications Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [User]
    {
        var models:[User] = []
        for item in array
        {
            models.append(User(dictionary: item as! NSDictionary)!)
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
        fullname = decoder.decodeObject(forKey:"fullname") as? String
        username = decoder.decodeObject(forKey:"username") as? String
        email = decoder.decodeObject(forKey:"email") as? String
        phone = decoder.decodeObject(forKey:"phone") as? String
        phone_code = decoder.decodeObject(forKey:"phone_code") as? String
        gender = decoder.decodeObject(forKey:"gender") as? String
        country = decoder.decodeObject(forKey:"country") as? String
        facebook_id = decoder.decodeObject(forKey:"facebook_id") as? String
        facebook_token = decoder.decodeObject(forKey:"facebook_token") as? String
        google_id = decoder.decodeObject(forKey:"google_id") as? String
        google_token = decoder.decodeObject(forKey:"google_token") as? String
        avatar = decoder.decodeObject(forKey:"avatar") as? String
        favorite_team = decoder.decodeObject(forKey:"favorite_team") as? String
        firebase_token = decoder.decodeObject(forKey:"firebase_token") as? String
        is_verified = decoder.decodeObject(forKey:"is_verified") as? Bool
        coins = decoder.decodeObject(forKey:"coins") as? String
        winning_coins = decoder.decodeObject(forKey:"winning_coins") as? String
        rank = decoder.decodeObject(forKey:"rank") as? String
        expected_winning_team = decoder.decodeObject(forKey:"expected_winning_team") as? String
        is_loggedIn = decoder.decodeObject(forKey:"is_loggedIn") as? Bool
        role = decoder.decodeObject(forKey:"role") as? String
        access_token = decoder.decodeObject(forKey:"access_token") as? String
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(fullname, forKey: "fullname")
        coder.encode(username, forKey: "username")
        coder.encode(email, forKey: "email")
        coder.encode(phone, forKey: "phone")
        coder.encode(phone_code, forKey: "phone_code")
        coder.encode(gender, forKey: "gender")
        coder.encode(country, forKey: "country")
        coder.encode(facebook_id, forKey: "facebook_id")
        coder.encode(facebook_token, forKey: "facebook_token")
        coder.encode(google_id, forKey: "google_id")
        coder.encode(google_token, forKey: "google_token")
        coder.encode(avatar, forKey: "avatar")
        coder.encode(favorite_team, forKey: "favorite_team")
        coder.encode(firebase_token, forKey: "firebase_token")
        coder.encode(is_verified, forKey: "is_verified")
        coder.encode(coins, forKey: "coins")
        coder.encode(winning_coins, forKey: "winning_coins")
        coder.encode(rank, forKey: "rank")
        coder.encode(expected_winning_team, forKey: "expected_winning_team")
        coder.encode(is_loggedIn, forKey: "is_loggedIn")
        coder.encode(role, forKey: "role")
        coder.encode(access_token, forKey: "access_token")
    }
    
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? String
        fullname = dictionary["fullname"] as? String
        username = dictionary["username"] as? String
        email = dictionary["email"] as? String
        phone = dictionary["phone"] as? String
        phone_code = dictionary["phone_code"] as? String
        gender = dictionary["gender"] as? String
        country = dictionary["country"] as? String
        facebook_id = dictionary["facebook_id"] as? String
        facebook_token = dictionary["facebook_token"] as? String
        google_id = dictionary["google_id"] as? String
        google_token = dictionary["google_token"] as? String
        avatar = dictionary["avatar"] as? String
        favorite_team = dictionary["favorite_team"] as? String
        firebase_token = dictionary["firebase_token"] as? String
        is_verified = dictionary["is_verified"] as? Bool
        coins = dictionary["coins"] as? String
        winning_coins = dictionary["winning_coins"] as? String
        rank = dictionary["rank"] as? String
        expected_winning_team = dictionary["expected_winning_team"] as? String
        is_loggedIn = dictionary["is_loggedIn"] as? Bool
        role = dictionary["role"] as? String
        access_token = dictionary["access_token"] as? String
    }
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(id, forKey: "id")
        dictionary.setValue(fullname, forKey: "fullname")
        dictionary.setValue(username, forKey: "username")
        dictionary.setValue(email, forKey: "email")
        dictionary.setValue(phone, forKey: "phone")
        dictionary.setValue(phone_code, forKey: "phone_code")
        dictionary.setValue(gender, forKey: "gender")
        dictionary.setValue(country, forKey: "country")
        dictionary.setValue(facebook_id, forKey: "facebook_id")
        dictionary.setValue(facebook_token, forKey: "facebook_token")
        dictionary.setValue(google_id, forKey: "google_id")
        dictionary.setValue(google_token, forKey: "google_token")
        dictionary.setValue(avatar, forKey: "avatar")
        dictionary.setValue(favorite_team, forKey: "favorite_team")
        dictionary.setValue(firebase_token, forKey: "firebase_token")
        dictionary.setValue(is_verified, forKey: "is_verified")
        dictionary.setValue(coins, forKey: "coins")
        dictionary.setValue(winning_coins, forKey: "winning_coins")
        dictionary.setValue(rank, forKey: "rank")
        dictionary.setValue(expected_winning_team, forKey: "expected_winning_team")
        dictionary.setValue(is_loggedIn, forKey: "is_loggedIn")
        dictionary.setValue(role, forKey: "role")
        dictionary.setValue(access_token, forKey: "access_token")
        
        return dictionary
    }
    
}

