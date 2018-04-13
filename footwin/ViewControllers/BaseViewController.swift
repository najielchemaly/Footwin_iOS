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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePickerDelegate.didCancelPickingMedia()
        
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
                userDefaults.synchronize()
                
                if let window = appDelegate.window {
                    if let loginNavigationController = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIds.LoginNavigationController) as? UINavigationController  {
                        window.rootViewController = loginNavigationController
                    }
                }
                
                self.hideLoader()
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
    func addEmptyView(message: String? = nil, frame: CGRect? = nil) {
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
        self.view.addSubview(self.alertView)

        let originalTopConstraint = self.alertView.contentTopConstraint.constant
        self.alertView.contentTopConstraint.constant = self.alertView.frame.size.height

        UIView.animate(withDuration: 0.1, animations: {
            self.alertView.viewOverlay.alpha = 1
        }, completion: { success in
            self.alertView.contentTopConstraint.constant = originalTopConstraint
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        })

        self.dismissKeyboard()
    }

    func hideAlertView() {
        if self.alertView != nil {
            self.alertView.contentTopConstraint.constant = self.alertView.frame.size.height
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


