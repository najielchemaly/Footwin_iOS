//
//  AppDefaults.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit

let GMS_APIKEY = ""
let APPLE_LANGUAGE_KEY = "AppleLanguages"
let DEVICE_LANGUAGE_KEY = "AppleLocale"

var currentVC: UIViewController!
var isUserLoggedIn: Bool = false
var isReview: Bool = false
var currentUser: User = User()
var notificationBadge: Int = 0
var firebaseToken: String!
var isAppActive: Bool = false
var tutorialText: String!

var appDelegate: AppDelegate {
    get {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            return delegate
        }
        
        return AppDelegate()
    }
}

var termsUrlString = Services.getBaseUrl() + "/terms"
var privacyUrlString = Services.getBaseUrl() + "/privacy"

enum Storyboards : String {
    case Main
    case Admin
    case LaunchScreen
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}

let mainStoryboard = Storyboards.Main.instance
let adminStoryboard = Storyboards.Admin.instance
let launchStoryboard = Storyboards.LaunchScreen.instance

struct Colors {
    static let appBlue: UIColor = UIColor(hexString: "#0e30dd")!
    static let appGreen: UIColor = UIColor(hexString: "#59cb21")!
    static let darkBlue: UIColor = UIColor(hexString: "#071a7b")!
    static let white: UIColor = UIColor(hexString: "#eef0f6")!
    static let red: UIColor = UIColor(hexString: "#d80e3f")!
    static let darkText: UIColor = UIColor(hexString: "#616b9a")!
    static let lightText: UIColor = UIColor(hexString: "#adb3d3")!
    static let xDarkBlue: UIColor = UIColor(hexString: "#102152")!
    static let black: UIColor = UIColor(hexString: "#000000")!
    static let lightGray: UIColor = UIColor(hexString: "#9297B0")!
}

struct Fonts {
    static let names: [String?] = UIFont.fontNames(forFamilyName: "Source Sans Pro")
    
    static var textFont_Light: UIFont {
        get {
            if let fontName = Fonts.names[0] {
                return UIFont.init(name: fontName, size: 18)!
            }
            
            return UIFont.init()
        }
    }
    
    static var textFont_Regular: UIFont {
        get {
            if let fontName = Fonts.names[1] {
                return UIFont.init(name: fontName, size: 18)!
            }
            
            return UIFont.init()
        }
    }
    
    static var textFont_Bold: UIFont {
        get {
            if let fontName = Fonts.names[2] {
                return UIFont.init(name: fontName, size: 20)!
            }
            
            return UIFont.init()
        }
    }
    
    static var textFont_SemiBold: UIFont {
        get {
            if let fontName = Fonts.names[3] {
                return UIFont.init(name: fontName, size: 18)!
            }
            
            return UIFont.init()
        }
    }
    
    static var textFont_Bold_XLarge: UIFont {
        get {
            if let fontName = Fonts.names[2] {
                return UIFont.init(name: fontName, size: 32)!
            }
            
            return UIFont.init()
        }
    }
}

struct StoryboardIds {
    static let SelectLanguageViewController: String = "SelectLanguageViewController"
    static let SignupViewController: String = "SignupViewController"
    static let NewsViewController: String = "NewsViewController"
    static let NotificationsViewController: String = "NotificationsViewController"
    static let ContactUsViewController: String = "ContactUsViewController"
    static let AboutViewController: String = "AboutViewController"
    static let ProfileViewController: String = "ProfileViewController"
    static let EditProfileViewController: String = "EditProfileViewController"
    static let LoginViewController: String = "LoginViewController"
    static let ForgotPasswordViewController: String = "ForgotPasswordViewController"
    static let HomeViewController: String = "HomeViewController"
    static let LoginNavigationController: String = "LoginNavigationController"
    static let WebViewController: String = "WebViewController"
    static let ChangePasswordViewController: String = "ChangePasswordViewController"
    static let NewsDetailViewController: String = "NewsDetailViewController"
    static let MyPredictionsViewController: String = "MyPredictionsViewController"
    static let LeaderboardViewController: String = "LeaderboardViewController"
    static let PredictViewController: String = "PredictViewController"
    static let CoinStashViewController: String = "CoinStashViewController"
    static let MainNavigationController: String = "MainNavigationController"
    static let LoadingViewController: String = "LoadingViewController"
    static let CountryViewController: String = "CountryViewController"
    static let AdminViewController: String = "AdminViewController"
    static let AdminNavigationController: String = "AdminNavigationController"
    static let OptionViewController: String = "OptionViewController"
    static let YoutubePlayerViewController: String = "YoutubePlayerViewController"
}

struct CellIds {
    static let NotificationsTableViewCell: String = "NotificationsTableViewCell"
    static let TeamCollectionViewCell: String = "TeamCollectionViewCell"
    static let PredictionTableViewCell: String = "PredictionTableViewCell"
    static let PurchaseCoinsViewCell: String = "PurchaseCoinsViewCell"
    static let NewsTableViewCell: String = "NewsTableViewCell"
    static let LeaderboardTableViewCell: String = "LeaderboardTableViewCell"
    static let MyPredictionTableViewCell: String = "MyPredictionTableViewCell"
    static let CountryTableViewCell: String = "CountryTableViewCell"
    static let AdminTableViewCell: String = "AdminTableViewCell"
    static let MatchTableViewCell: String = "MatchTableViewCell"
}

struct Views {
    static let AlertView: String = "AlertView"
    static let EmptyView: String = "EmptyView"
    static let HelperView: String = "HelperView"
    static let TutorialView: String = "TutorialView"
    static let RulesView: String = "RulesView"
    static let ExactScoreView: String = "ExactScoreView"
    static let PurchaseCoins: String = "PurchaseCoins"
}

enum Keys: String {
    case UserId = "User-Id"
    case AppLanguage = "APP-LANGUAGE"
    case AppVersion = "APP-VERSION"
    case DeviceId = "ID"
}

enum SegueId: String {
    case None
    
    var identifier: String {
        return String(describing: self).lowercased()
    }
}

enum Language: Int {
    
    case Arabic = 1
    case English = 2
    
}

enum NewsType {
    case None
    
    var identifier: String {
        return String(describing: self).lowercased()
    }
}

public enum WebViewComingFrom {
    case None
    case Terms
    case Privacy
}

enum FieldType: String {
    case Fullname
    case Username
    case Email
    case Password
    case Country
    case Phone
    case Gender
    
    var title: String {
        return String(describing: self)
    }
}

enum ValidationType: String {
    case Required
    case MaxLength
    case MinLength
    case Regex
    case Passwords
}

func getYears() -> NSMutableArray {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy"
    let strDate = formatter.string(from: Date.init())
    if let intDate = Int(strDate) {
        let yearsArray: NSMutableArray = NSMutableArray()
        for i in (1964...intDate).reversed() {
            yearsArray.add(String(format: "%d", i))
        }
        
        return yearsArray
    }
    
    return NSMutableArray()
}

func getYearsFrom(yearString: String) -> String {
    let currentYearString = Calendar.current.component(Calendar.Component.year, from: Date())
    if let year = Int(yearString) {
        let currentYear = Int(currentYearString)
        return String(currentYear-year)
    }
    
    return yearString
}

public func timeAgoSince(_ date: Date) -> String {
    
    let calendar = Calendar.current
    let now = Date()
    let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
    let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
    
    if let year = components.year, year >= 2 {
        return "\(year) years ago"
    }
    
    if let year = components.year, year >= 1 {
        return "Last year"
    }
    
    if let month = components.month, month >= 2 {
        return "\(month) months ago"
    }
    
    if let month = components.month, month >= 1 {
        return "Last month"
    }
    
    if let week = components.weekOfYear, week >= 2 {
        return "\(week) weeks ago"
    }
    
    if let week = components.weekOfYear, week >= 1 {
        return "Last week"
    }
    
    if let day = components.day, day >= 2 {
        return "\(day) days ago"
    }
    
    if let day = components.day, day >= 1 {
        return "Yesterday"
    }
    
    if let hour = components.hour, hour >= 2 {
        return "\(hour) hours ago"
    }
    
    if let hour = components.hour, hour >= 1 {
        return "An hour ago"
    }
    
    if let minute = components.minute, minute >= 2 {
        return "\(minute) minutes ago"
    }
    
    if let minute = components.minute, minute >= 1 {
        return "A minute ago"
    }
    
    if let second = components.second, second >= 3 {
        return "Just now"
    }
    
    return "Just now"
    
}

func updateNotificationBadge() {
    let userDefaults = UserDefaults.standard
    if let notificationNumber = userDefaults.value(forKey: "notificationNumber") as? String {
        if let notificationBadge = Int(notificationNumber) {
            userDefaults.set(String(describing: notificationBadge + 1), forKey: "notificationNumber")
        }
    } else {
        userDefaults.set(String(describing: "1"), forKey: "notificationNumber")
    }
    userDefaults.synchronize()
}

