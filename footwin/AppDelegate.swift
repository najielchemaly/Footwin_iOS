//
//  AppDelegate.swift
//  footwin
//
//  Created by MR.CHEMALY on 3/26/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import UserNotifications
import FBSDKCoreKit
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    private var _services: Services!
    var services: Services {
        get {
            if _services == nil {
                _services = Services.init()
            }
            
            return _services
        }
    }
    
    var window: UIWindow?
    
    let gcmMessageIDKey: String = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        getConfig() { data in
            if let jsonData = data as Data? {
                if let json = String(data: jsonData, encoding: .utf8) {
                    if let dict = JSON.init(parseJSON: json).dictionary {
                        if let base_url = dict["base_url"] {
                            Services.setBaseUrl(url: base_url.stringValue)
                        }
                        if let media_url = dict["media_url"] {
                            Services.setMediaUrl(url: media_url.stringValue)
                        }
                        if let is_review = dict["is_review"] {
                            isReview = is_review.boolValue
                        }
                        if let countries = dict["countries"] {
                            if let jsonArray = countries.arrayObject as? [NSDictionary] {
                                for json in jsonArray {
                                    let country = _Country.init(dictionary: json)
                                    Objects.countries.append(country!)
                                }
                            }
                        }
                        if let teams = dict["teams"] {
                            if let jsonArray = teams.arrayObject as? [NSDictionary] {
                                for json in jsonArray {
                                    let team = Team.init(dictionary: json)
                                    Objects.teams.append(team!)
                                }
                            }
                        }
                        if let active_round = dict["active_round"] {
                            if let json = active_round.dictionaryObject as NSDictionary? {
                                Objects.activeRound = Round.init(dictionary: json)!
                            }
                        }
                    }
                }
            }
            
            if let data = UserDefaults.standard.data(forKey: "user"),
                let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User {
                
            }
        }
        
        //        Localization.doTheExchange()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        let isNotificationOn = UserDefaults.standard.value(forKey: "isNotificationOn")
        if let isOn = isNotificationOn as? Bool, isOn || isNotificationOn == nil {
            FirebaseApp.configure()
            
            if #available(iOS 10.0, *) {
                // For iOS 10 display notification (sent via APNS)
                UNUserNotificationCenter.current().delegate = self
                
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(
                    options: authOptions,
                    completionHandler: {_, _ in })
            } else {
                let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                application.registerUserNotificationSettings(settings)
            }
            
            self.registerForRemoteNotifications()
            
            Messaging.messaging().delegate = self
        }
        
        return true
    }
    
    func getConfig(completion:@escaping (NSData?) -> ()) {
        var request = URLRequest(url: URL(string: Services.ConfigUrl)!)
        request.httpMethod = "POST"
        let session = URLSession.shared
        
        session.dataTask(with: request) { data, response, error in
            if error == nil{
                return completion(data as NSData?)
            }else{
                return completion(nil)
            }
            }.resume()
    }
    
    func unregisterFromRemoteNotifications() {
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    
    func registerForRemoteNotifications() {
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        var sourceApplication: String = ""
        var annotation: String = ""
        if options[.sourceApplication] != nil {
            sourceApplication = options[.sourceApplication] as! String
        }
        if options[.annotation] != nil {
            annotation = options[.annotation] as! String
        }
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        return handled
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        return handled
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        
        if let fcmToken = Messaging.messaging().fcmToken {
            
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // Let FCM know about the message for analytics etc.
        Messaging.messaging().appDidReceiveMessage(userInfo)
        // handle your message
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "footwin")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

