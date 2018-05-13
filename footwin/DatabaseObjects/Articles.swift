//
//  Articles.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/20/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import Foundation

public class Article: NSObject, NSCoding {
    public var source : ArticleSource?
    public var author : String?
    public var title : String?
    public var desc : String?
    public var url : String?
    public var url_to_image : String?
    public var published_at : String?
    public var date : Date?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let Notifications_list = Notifications.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Notifications Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Article]
    {
        var models:[Article] = []
        for item in array
        {
            models.append(Article(dictionary: item as! NSDictionary)!)
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
        source = decoder.decodeObject(forKey:"source") as? ArticleSource
        author = decoder.decodeObject(forKey:"author") as? String
        title = decoder.decodeObject(forKey:"title") as? String
        desc = decoder.decodeObject(forKey:"description") as? String
        url = decoder.decodeObject(forKey:"url") as? String
        url_to_image = decoder.decodeObject(forKey:"urlToImage") as? String
        published_at = decoder.decodeObject(forKey:"publishedAt") as? String
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(source, forKey: "source")
        coder.encode(author, forKey: "author")
        coder.encode(title, forKey: "title")
        coder.encode(desc, forKey: "description")
        coder.encode(url, forKey: "url")
        coder.encode(url_to_image, forKey: "urlToImage")
        coder.encode(published_at, forKey: "publishedAt")
    }
    
    required public init?(dictionary: NSDictionary) {
        
        source = dictionary["source"] as? ArticleSource
        author = dictionary["author"] as? String
        title = dictionary["title"] as? String
        desc = dictionary["description"] as? String
        url = dictionary["url"] as? String
        url_to_image = dictionary["urlToImage"] as? String
        published_at = dictionary["publishedAt"] as? String
        if let publishedAt = published_at {
            let dateArray = publishedAt.split(separator: "-")
            let timeArray = dateArray[2].split(separator: "T")
            let dateString = dateArray[0]+"-"+dateArray[1]+"-"+timeArray[0]
            let dateFormatter = DateFormatter()
            if let timeZone = NSTimeZone(name: "GMT") as TimeZone? {
                dateFormatter.timeZone = timeZone
            }
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: dateString) {
                self.date = date
            }
        }
    }
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(source, forKey: "source")
        dictionary.setValue(author, forKey: "author")
        dictionary.setValue(description, forKey: "description")
        dictionary.setValue(url, forKey: "url")
        dictionary.setValue(url_to_image, forKey: "urlToImage")
        dictionary.setValue(published_at, forKey: "publishedAt")
        
        return dictionary
    }
    
}
