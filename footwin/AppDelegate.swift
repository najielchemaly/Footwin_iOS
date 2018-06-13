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
import GoogleMobileAds
import InMobiSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    private var _services: Services!
    var services: Services {
        get {
//            if _services == nil {
                _services = Services.init()
//            }
            
            return _services
        }
    }
    
    var window: UIWindow?
    
    var didFinishLaunching: Bool = false
    
    let gcmMessageIDKey: String = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if let window = window {
            let loadingViewController = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIds.LoadingViewController)
            window.rootViewController = loadingViewController
        }

        // Use Firebase library to configure APIs.
        FirebaseApp.configure()
        
        // Initialize the Google Mobile Ads SDK.
//        GADMobileAds.configure(withApplicationID: ADMOB_APP_ID)
        
        // Initialize the InMobi Mobile Ads SDK.
        let conscentDict: NSDictionary = [IM_GDPR_CONSENT_AVAILABLE : "true"]
        IMSdk.initWithAccountID(INMOBI_ACCOUNT_ID, consentDictionary:conscentDict as! [AnyHashable : Any])
        /*
         * Enable logging for better debuggability. Please turn off the logs before submitting your App to the AppStore
         */
        IMSdk.setLogLevel(IMSDKLogLevel.debug)
        
        self.setupGoogleAnalytics()
        self.setupConfiguration()
        
        //        Localization.doTheExchange()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        let isNotificationOn = UserDefaults.standard.value(forKey: "isNotificationOn")
        if isNotificationOn == nil || (isNotificationOn as? Bool)! {
//            FirebaseApp.configure()
            
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
    
    func setupGoogleAnalytics() {
//        guard let gai = GAI.sharedInstance() else {
//            assert(false, "Google Analytics not configured correctly")
//            return
//        }
//        gai.tracker(withTrackingId: GOOGLE_TRACKING_ID)
//        // Optional: automatically report uncaught exceptions.
//        gai.trackUncaughtExceptions = true
//        
//        // Optional: set Logger to VERBOSE for debug information.
//        // Remove before app release.
//        gai.logger.logLevel = .verbose
    }
    
    func setupConfiguration() {
        getConfig() { data in
            if let jsonData = data as Data? {
                if let json = String(data: jsonData, encoding: .utf8) {
                    if let dict = JSON.init(parseJSON: json).dictionary {
                        if let version_ios = dict["version_ios"], let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                            if let recVersion = Double(version_ios.stringValue.replacingOccurrences(of: ".", with: "")), let currentVersion = Double(version.replacingOccurrences(of: ".", with: "")) {
                                if recVersion > currentVersion {
                                    DispatchQueue.main.async {
                                        if let rootVC = self.window?.rootViewController {
                                            let alert = UIAlertController(title: "OOPS", message: "Your current version is out of date.\nPlease update the app!", preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "UPDATE", style: .default, handler: { action in
                                                self.didFinishLaunching = true
                                                self.openFootinInAppStore()
                                            }))
                                            rootVC.present(alert, animated: true, completion: nil)
                                        }
                                    }
                                    
                                    return
                                }
                            }
                        }
                        if let base_url = dict["base_url"] {
                            Services.setBaseUrl(url: base_url.stringValue)
                        }
                        if let media_url = dict["media_url"] {
                            Services.setMediaUrl(url: media_url.stringValue)
                        }
                        if let news_url = dict["news_url"] {
                            Services.setNewsUrl(url: news_url.stringValue)
                        }
                        if let admin_url = dict["admin_url"] {
                            Services.setAdminUrl(url: admin_url.stringValue)
                        }
                        if let is_review = dict["is_review"] {
                            isReview = is_review.boolValue
                        }
                        if let is_iapready = dict["is_iapready"] {
                            isIAPReady = is_iapready.boolValue
                        }
                        if let tutorial_text = dict["tutorial_text"] {
                            tutorialText = tutorial_text.stringValue
                        }
                        if let countries = dict["countries"] {
                            if let jsonArray = countries.arrayObject as? [NSDictionary] {
                                for json in jsonArray {
                                    let country = Country.init(dictionary: json)
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
                        if let active_reward = dict["active_reward"] {
                            if let json = active_reward.dictionaryObject as NSDictionary? {
                                Objects.activeReward = Reward.init(dictionary: json)!
                            }
                        }
                        if let winning_user = dict["winning_user"] {
                            if let json = winning_user.dictionaryObject as NSDictionary? {
                                Objects.winningUser = User.init(dictionary: json)!
                            }
                        }
                        if let is_app_active = dict["is_app_active"] {
                            isAppActive = is_app_active.boolValue
//                            if isAppActive {
                                DispatchQueue.main.async {
                                    if UserDefaults.standard.bool(forKey: "didLaunchFirstTime") {
                                        if let data = UserDefaults.standard.data(forKey: "user"),
                                            let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User {
                                            currentUser = user
                                            if currentUser.role == "2" {
                                                if let window = self.window, let adminNavigationController = adminStoryboard.instantiateViewController(withIdentifier: StoryboardIds.AdminNavigationController) as? UINavigationController {
                                                    window.rootViewController = adminNavigationController
                                                }
                                            } else {
                                                DispatchQueue.global(qos: .background).async {
                                                    let access_token = currentUser.access_token ?? ""
                                                    let response = self.services.login(access_token: access_token)
                                                    
                                                    DispatchQueue.main.async {
                                                        if response?.status == ResponseStatus.SUCCESS.rawValue {
                                                            if let json = response?.json?.first {
                                                                if let jsonUser = json["user"] as? NSDictionary {
                                                                    if let user = User.init(dictionary: jsonUser) {
                                                                        currentUser = user
                                                                        
                                                                        if let baseVC = currentVC as? BaseViewController {
                                                                            baseVC.saveUserInUserDefaults()
                                                                        }
                                                                        
                                                                        if isAppActive {
                                                                            self.goToMainNavigation()
                                                                        } else {
                                                                            self.goToYoutubeNavigation()
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        } else {
                                                            self.goToLoginNavigation()
                                                        }
                                                    }
                                                }
                                            }
                                        } else {
                                            self.goToLoginNavigation()
                                        }
                                    } else {
                                        self.goToLoginNavigation()
                                        // TODO Change when the trailer is ready
//                                        self.goToYoutubeNavigation()
                                    }
                                }
//                            }
//                            else {
//                                DispatchQueue.main.async {
//                                    self.goToYoutubeNavigation()
//                                }
//                            }
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    if let rootVC = self.window?.rootViewController {
                        let alert = UIAlertController(title: "Connection Timeout", message: "Check your internet connection", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
                            self.setupConfiguration()
                        }))
                        rootVC.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func openFootinInAppStore() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id1373217518"),
            UIApplication.shared.canOpenURL(url)
        {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func goToLoginNavigation() {
        if let window = self.window, let loginNavigationController = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIds.LoginNavigationController) as? LoginNavigationController {
            window.rootViewController = loginNavigationController
            self.didFinishLaunching = true
        }
    }
    
    func goToMainNavigation() {
        if let window = self.window, let mainNavigationController = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIds.MainNavigationController) as? MainNavigationController {
            window.rootViewController = mainNavigationController
            self.didFinishLaunching = true
        }
    }
    
    func goToYoutubeNavigation() {
        if let window = self.window, let youtubePlayerViewController = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIds.YoutubePlayerViewController) as? YoutubePlayerViewController {
            window.rootViewController = youtubePlayerViewController
            self.didFinishLaunching = true
        }
    }
    
    @objc func getConfig(completion:@escaping (NSData?) -> ()) {
        var request = URLRequest(url: URL(string: Services.ConfigUrl)!)
        request.httpMethod = "POST"
        request.timeoutInterval = 30
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
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
            firebaseToken = fcmToken
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
            
            DispatchQueue.main.async {
                if let type = userInfo["type"] as? String, type == "update_active_matches" {
                    if let predictVC = currentVC as? PredictViewController {
                        predictVC.handleRefresh(fromNotification: true)
                    } else {
                        let response = self.services.getMatches()
                        if response?.status == ResponseStatus.SUCCESS.rawValue {
                            if let json = response?.json?.first {
                                if let jsonArray = json["matches"] as? [NSDictionary] {
                                    Objects.matches = [Match]()
                                    for json in jsonArray {
                                        let match = Match.init(dictionary: json)
                                        Objects.matches.append(match!)
                                    }
                                }
                            }
                        }
                    }
                    
                    let response = self.services.getActiveRound()
                    if response?.status == ResponseStatus.SUCCESS.rawValue {
                        if let json = response?.json?.first {
                            if let active_round = json["active_round"] as? NSDictionary {
                                Objects.activeRound = Round.init(dictionary: active_round)!
                            }
                            if let active_reward = json["active_reward"] as? NSDictionary {
                                Objects.activeReward = Reward.init(dictionary: active_reward)!
                            }
                        }
                    }
                    
                    return
                }
                
                updateNotificationBadge()
                
                if let total_winning_coins = userInfo["total_winning_coins"] as? String {
                    currentUser.winning_coins = total_winning_coins
                }
                
                if let baseVC = currentVC as? BaseViewController {
                    baseVC.redirectToVC(storyboard: mainStoryboard, storyboardId: StoryboardIds.NotificationsViewController, type: .present)
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
            
            DispatchQueue.main.async {
                if let type = userInfo["type"] as? String, type == "update_active_matches" {
                    if let predictVC = currentVC as? PredictViewController {
                        predictVC.handleRefresh(fromNotification: true)
                    } else {
                        _ = self.services.getMatches()
                    }
                    
                    return
                }
                
                updateNotificationBadge()
                
                if let total_winning_coins = userInfo["total_winning_coins"] as? String {
                    currentUser.winning_coins = total_winning_coins
                }
                
                if let predictVC = currentVC as? PredictViewController {
                    predictVC.setNotificationBadgeNumber(label: predictVC.labelBadge)
                    predictVC.labelWinningCoins.text = currentUser.winning_coins
                } else if let notificationsVC = currentVC as? NotificationsViewController {
                    notificationsVC.handleRefresh()
                }
            }
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
        if didFinishLaunching {
            DispatchQueue.global(qos: .background).async {
                let response = self.services.checkVersion()
                
                DispatchQueue.main.async {
                    if response?.status == ResponseStatus.FAILURE.rawValue, let json = response?.json?.first {
                        if let status = json["status"] as? Int, status == 0 {
                            if let window = self.window {
                                var rootVC: UIViewController!
                                if let loadingVC = window.rootViewController as? LoadingViewController {
                                    rootVC = loadingVC
                                } else {
                                    let loadingViewController = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIds.LoadingViewController)
                                    window.rootViewController = loadingViewController
                                    rootVC = loadingViewController
                                }
                                
                                if let message = response?.message {
                                    let alert = UIAlertController(title: "OOPS", message: message, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "UPDATE", style: .default, handler: { action in
                                        self.openFootinInAppStore()
                                    }))
                                    rootVC.present(alert, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0
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

