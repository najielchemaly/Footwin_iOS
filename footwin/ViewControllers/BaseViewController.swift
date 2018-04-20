//
//  ViewController.swift
//  footwin
//
//  Created by MR.CHEMALY on 3/26/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Kingfisher
import FirebaseMessaging

protocol ImagePickerDelegate {
    func didFinishPickingMedia(data: UIImage?)
    func didCancelPickingMedia()
}

class BaseViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePickerDelegate: ImagePickerDelegate!
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipe.direction = .down
        self.view.addGestureRecognizer(swipe)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        self.imagePickerController.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentVC = self
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func handleCameraTap(sender: UIButton? = nil) {
        let optionActionSheet = UIAlertController(title: NSLocalizedString("Select Source", comment: ""), message: nil, preferredStyle: .actionSheet)
        optionActionSheet.addAction(UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default, handler: openCamera))
        optionActionSheet.addAction(UIAlertAction(title: NSLocalizedString("Library", comment: ""), style: .default, handler: openPhotoLibrary))
        optionActionSheet.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        
        present(optionActionSheet, animated: true, completion: nil)
    }
    
    func openCamera(action: UIAlertAction) {
        self.imagePickerController.sourceType = .camera
        
        present(self.imagePickerController, animated: true, completion: nil)
    }
    
    func openPhotoLibrary(action: UIAlertAction) {
        self.imagePickerController.sourceType = .photoLibrary
        
        present(self.imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePickerDelegate.didCancelPickingMedia()

        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var pickedImage: UIImage? = nil

        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            pickedImage = image
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pickedImage = image
        }

        self.imagePickerDelegate.didFinishPickingMedia(data: pickedImage)
        dismiss(animated: true, completion: nil)
    }
    
    func saveUserInUserDefaults() {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: currentUser)
        let userDefaults = UserDefaults.standard
        userDefaults.set(encodedData, forKey: "user")
        userDefaults.set(true, forKey: "isUserLoggedIn")
        userDefaults.synchronize()
    }
    
    func openURL(url: URL) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @objc func logout() {
        self.showLoader()
        
        let userId = currentUser.id
        DispatchQueue.global(qos: .background).async {
            _ = appDelegate.services.logout(id: String(describing: userId))
            
            DispatchQueue.main.async {
                let userDefaults = UserDefaults.standard
                userDefaults.removeObject(forKey: "user")
                userDefaults.removeObject(forKey: "isUserLoggedIn")
                userDefaults.removeObject(forKey: "firebaseToken")
                userDefaults.synchronize()
                
                if let window = appDelegate.window {
                    if let loginNavigationController = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIds.LoginNavigationController) as? UINavigationController  {
                        window.rootViewController = loginNavigationController
                    }
                }
                
                self.hideLoader()
                
                Messaging.messaging().unsubscribe(fromTopic: "/topics/footwinnews")
                appDelegate.unregisterFromRemoteNotifications()
            }
        }
    }
    
    func showLoader(message: String? = nil, type: NVActivityIndicatorType? = .ballRotateChase,
                    color: UIColor? = nil , textColor: UIColor? = nil) {
        let activityData = ActivityData(message: message, type: type, color: color, textColor: textColor)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        self.dismissKeyboard()
    }
    
    func hideLoader() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
    private var emptyView: EmptyView!
    func addEmptyView(message: String? = nil, frame: CGRect? = nil, padding: CGFloat = 8) {
        if self.emptyView == nil {
            let view = Bundle.main.loadNibNamed("EmptyView", owner: self.view, options: nil)
            if let emptyView = view?.first as? EmptyView {
                self.emptyView = emptyView
                self.view.addSubview(self.emptyView)
            }
        }

        self.emptyView.frame = frame ?? self.view.frame
        self.emptyView.labelTitle.text = message
        self.emptyView.isUserInteractionEnabled = false
    }

    func removeEmptyView() {
        if self.emptyView != nil {
            self.emptyView.removeFromSuperview()
        }
    }
    
    var alertView: AlertView!
    func showAlertView(title: String? = nil, message: String, cancelTitle: String? = nil, doneTitle: String? = nil) {
        let view = Bundle.main.loadNibNamed("AlertView", owner: self.view, options: nil)
        if let alertView = view?.first as? AlertView {
            self.alertView = alertView
        }

        self.alertView.labelMessage.text = message.uppercased()

        if title != nil {
            self.alertView.labelTitle.text = title
        }

        if cancelTitle != nil {
            self.alertView.buttonCancel.setTitle(cancelTitle?.uppercased(), for: .normal)
        } else {
            self.alertView.buttonCancel.removeFromSuperview()
        }

        if doneTitle != nil {
            self.alertView.buttonDone.setTitle(doneTitle?.uppercased(), for: .normal)
        }

        self.alertView.frame = self.view.bounds
        self.alertView.viewOverlay.alpha = 0
        self.alertView.viewCenterYConstraint.constant = self.alertView.frame.size.height
        appDelegate.window?.addSubview(self.alertView)

        UIView.animate(withDuration: 0.1, animations: {
            self.alertView.viewOverlay.alpha = 1
        }, completion: { success in
            self.alertView.viewCenterYConstraint.constant = 0
            UIView.animate(withDuration: 0.2, animations: {
                appDelegate.window?.layoutIfNeeded()
            })
        })

        self.dismissKeyboard()
    }

    func hideAlertView() {
        if self.alertView != nil {
            self.alertView.viewCenterYConstraint.constant = self.alertView.frame.size.height
            UIView.animate(withDuration: 0.2, animations: {
                appDelegate.window?.layoutIfNeeded()
            }, completion: { success in
                self.alertView.removeFromSuperview()
            })
        }
    }
    
    func setNotificationBadgeNumber(label: UILabel) {
        if let notificationNumber = UserDefaults.standard.value(forKey: "notificationNumber") as? String {
            label.text = notificationNumber
            if notificationNumber.isEmpty || notificationNumber == "0" {
                label.isHidden = true
            } else {
                label.isHidden = false
            }
        } else {
            label.text = nil
            label.isHidden = true
        }
    }
    
    var customView = UIView()
    func showView(name: String) -> UIView {
        let duration = 0.3
        let view = Bundle.main.loadNibNamed(name, owner: self.view, options: nil)
        if let helperView = view?.first as? HelperView {
            customView = helperView
            customView.frame = self.view.bounds
            customView.backgroundColor = Colors.black.withAlphaComponent(0.6)
        } else if let tutorialView = view?.first as? TutorialView {
            customView = tutorialView
            customView.frame = self.view.bounds
            customView.backgroundColor = Colors.black.withAlphaComponent(0.8)
        } else if let rulesView = view?.first as? RulesView {
            customView = rulesView
            customView.frame = self.view.bounds
            customView.backgroundColor = Colors.black.withAlphaComponent(0.8)
        } else if let exactScoreView = view?.first as? ExactScoreView {
            customView = exactScoreView
            customView.frame = self.view.bounds
            customView.backgroundColor = Colors.black.withAlphaComponent(0.8)
        } else if let purchaseCoins = view?.first as? PurchaseCoins {
            customView = purchaseCoins
            customView.frame = self.view.bounds
            customView.backgroundColor = Colors.black.withAlphaComponent(0.9)
        }
        
        customView.alpha = 0
        appDelegate.window?.addSubview(customView)
        
        UIView.animate(withDuration: duration, animations: {
            self.customView.alpha = 1
        })
        
        return customView
    }
    
    func getPackages() {
//        self.showLoader()
        DispatchQueue.global(qos: .background).async {
            let response = appDelegate.services.getPackages()
            
            DispatchQueue.main.async {
                if response?.status == ResponseStatus.SUCCESS.rawValue {
                    if let json = response?.json?.first {
                        if let jsonArray = json["packages"] as? [NSDictionary] {
                            Objects.packages = [Package]()
                            for json in jsonArray {
                                let package = Package.init(dictionary: json)
                                Objects.packages.append(package!)
                            }
                        }
                    }
                }
//                self.hideLoader()
            }
        }
    }
    
    enum Week: Int {
        case one = 7, two = 14, three = 21
    }
    
    struct CountDown {
        // Customize this if you want to change timeRemaining's format
        // It automatically take care of singular vs. plural, i.e. 1 hr and 2 hrs
        private static let dateComponentFormatter: DateComponentsFormatter = {
            var formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.day, .hour, .minute, .second]
            formatter.unitsStyle = .short
            return formatter
        }()
        
        var listingDate: Date
        var duration: Week
        var expirationDate: Date {
            return Calendar.current.date(byAdding: .day, value: duration.rawValue, to: listingDate)!
        }
        
        var timeRemaining: String {
            let now = Date()
            
            if expirationDate <= now {
                return String()
            } else {
                let timeRemaining = CountDown.dateComponentFormatter.string(from: now, to: expirationDate)!
                return timeRemaining
            }
        }
    }
    
    func getTimeRemaining(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        if let date = dateFormatter.date(from: dateString) {
            let listing = CountDown(listingDate: date, duration: .one)
            
            return String (describing: listing.timeRemaining)
        }
        
        return String()
    }
    
    func setupTimer(object: AnyObject, cell: UITableViewCell) {
        if let match = object as? Match {
            match.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
                if let cell = cell as? PredictionTableViewCell {
                    let timeRemaining = self.getTimeRemaining(dateString: match.date!)
                    if !timeRemaining.isEmpty {
                        cell.labelTime.text = timeRemaining
                    }
                }
            })
        } else if let prediction = object as? Prediction {
            prediction.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
                if let cell = cell as? MyPredictionTableViewCell {
                    let timeRemaining = self.getTimeRemaining(dateString: prediction.date!)
                    if !timeRemaining.isEmpty {
                        cell.labelDescription.text = timeRemaining
                    }
                }
            })
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

