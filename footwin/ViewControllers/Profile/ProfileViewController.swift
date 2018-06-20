//
//  ProfileViewController.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController, ImagePickerDelegate {

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var buttonCamera: UIButton!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var viewOverlay: UIView!
    @IBOutlet weak var buttonChangePassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setUserInfo()
    }
    
    func initializeViews() {
        self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width/2
        self.viewOverlay.layer.cornerRadius = self.viewOverlay.frame.size.width/2
        
        if currentUser.facebook_id != nil && currentUser.facebook_id != "" {
            buttonChangePassword.isEnabled(enable: false)
        }
        
        self.imagePickerDelegate = self
    }
    
    func setUserInfo() {
        labelName.text = currentUser.fullname?.uppercased()
        if let avatar = currentUser.avatar, !avatar.isEmpty {
            let urlString = avatar.contains("graph.facebook.com") ? avatar : Services.getMediaUrl() + avatar
            self.imageProfile.kf.setImage(with: URL(string: urlString))
        } else {
            if let gender = currentUser.gender, gender.lowercased() == "male" {
                self.imageProfile.image = #imageLiteral(resourceName: "avatar_male")
            } else if let gender = currentUser.gender, gender.lowercased() == "female" {
                self.imageProfile.image = #imageLiteral(resourceName: "avatar_female")
            }
        }
    }
    
    func didFinishPickingMedia(data: UIImage?) {
        if let image = data {
            self.imageProfile.image = image
            
            if let userId = currentUser.id {
                DispatchQueue.global(qos: .background).async {
                    appDelegate.services.updateAvatar(userId: userId, image: image, completion: { data in
                        
                        DispatchQueue.main.async {
                            if let json = data.json?.first {
                                if let status = json["status"] as? Int, status == ResponseStatus.SUCCESS.rawValue {
                                    self.saveUserInUserDefaults()
                                    
                                    self.showAlertView(title: "CHANGE AVATAR", message: "Your profile picture has been updated successfully")
                                } else {
                                    self.showAlertView(message: ResponseMessage.SERVER_UNREACHABLE.rawValue)
                                }
                            }
                            
                            self.hideLoader()
                        }
                    })
                }
            }
        }
    }
    
    func didCancelPickingMedia() {
        
    }
    
    @IBAction func buttonCameraTapped(_ sender: Any) {
        self.handleCameraTap()
    }
    
    @IBAction func buttonMyPredictionsTapped(_ sender: Any) {
        self.redirectToVC(storyboardId: StoryboardIds.MyPredictionsViewController, type: .present)
    }
    
    @IBAction func buttonPrivacyTapped(_ sender: Any) {
        WebViewController.comingFrom = WebViewComingFrom.Privacy
        self.redirectToVC(storyboardId: StoryboardIds.WebViewController, type: .present)
    }
    
    @IBAction func buttonEditProfileTapped(_ sender: Any) {
        self.redirectToVC(storyboardId: StoryboardIds.EditProfileViewController, type: .present)
    }
    
    @IBAction func buttonChangePasswordTapped(_ sender: Any) {
        self.redirectToVC(storyboardId: StoryboardIds.ChangePasswordViewController, type: .present)
    }
    
    @IBAction func buttonTermsTapped(_ sender: Any) {
        WebViewController.comingFrom = WebViewComingFrom.Terms
        self.redirectToVC(storyboardId: StoryboardIds.WebViewController, type: .present)
    }
    
    @IBAction func buttonLogoutTapped(_ sender: Any) {
        self.showAlertView(title: "LOGOUT", message: "Are you sure you want to logout?", cancelTitle: "CANCEL", doneTitle: "YES")
        self.alertView.buttonDone.addTarget(self, action: #selector(self.logout), for: .touchUpInside)
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
