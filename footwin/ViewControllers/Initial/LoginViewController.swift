//
//  LoginViewController.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseMessaging

class LoginViewController: BaseViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var buttonForgotPassword: UIButton!
    @IBOutlet weak var buttonContinueWithFB: UIButton!
    @IBOutlet weak var buttonContinueWithGmail: UIButton!
    @IBOutlet weak var buttonSignup: UIButton!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var loginButton: FBSDKLoginButton!
    var loginManager: FBSDKLoginManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initializeViews()
        self.setupDelegates()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UserDefaults.standard.set(true, forKey: "didLaunchFirstTime")
        UserDefaults.standard.synchronize()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > 0 || scrollView.contentOffset.x < 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    @IBAction func buttonLoginTapped(_ sender: Any) {
        if isValidData() {
            self.showLoader()
            
            let email = self.textFieldEmail.text
            let password = self.textFieldPassword.text
            DispatchQueue.global(qos: .background).async {
                let response = appDelegate.services.login(email: email!, password: password!)
                
                DispatchQueue.main.async {
                    if response?.status == ResponseStatus.SUCCESS.rawValue {
                        if let json = response?.json?.first {
                            if let jsonUser = json["user"] as? NSDictionary {
                                if let user = User.init(dictionary: jsonUser) {
                                    currentUser = user
                                    
                                    self.saveUserInUserDefaults()
                                    
                                    if currentUser.role == "3" {
                                        self.navigateToHome()
                                    } else {
                                        self.navigateToAdmin()
                                    }
                                }
                            }
                        }
                    } else if let message = response?.message {
                        self.showAlertView(message: message)
                    }
                    
                    self.hideLoader()
                }
            }
        } else {
            self.showAlertView(message: errorMessage)
        }
    }
    
    @IBAction func buttonContinueWithFBTapped(_ sender: Any) {
        // show loader
        if (FBSDKAccessToken.current()) != nil
            //            , currentAccessToken.appID != FBSDKSettings.appID()
        {
            loginManager.logOut()
        }
        
        loginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self, handler: { result, error in
            if error != nil {
                print(error!)
            } else if (result?.isCancelled)! {
                DispatchQueue.main.async {
                    // hide loader
                }
            } else if result?.grantedPermissions != nil {
                currentUser = User()
                currentUser.facebook_token = result?.token.tokenString
                
                self.getFacebookParameters()
            }
        })
    }
    
    func initializeViews() {
        self.buttonForgotPassword.setAttributedText(firstText: "FORGOT YOUR PASSWORD?", secondText: " RECOVER IT", color: .white)
        self.buttonForgotPassword.titleLabel?.adjustsFontSizeToFitWidth = true
        
        self.viewEmail.customizeBorder(color: Colors.white)
        self.viewPassword.customizeBorder(color: Colors.white)
        
        self.loginButton = FBSDKLoginButton()
        self.loginButton.readPermissions = ["public_profile", "email"]
        
        self.loginManager = FBSDKLoginManager()
    }
    
    func getFacebookParameters(){
        self.showLoader()
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email, name, gender, location, picture, birthday"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil)
            {
                if let dict = result as? NSDictionary {
                    if let gender = (dict.object(forKey: "gender") as? String) {
                        currentUser.gender = gender
                    }
                    if let id = (dict.object(forKey: "id") as? String) {
                        currentUser.facebook_id = id
                        
                        currentUser.avatar = "http://graph.facebook.com/\(id)/picture?type=large"
                    }
                    if let name = (dict.object(forKey: "name") as? String) {
                        currentUser.fullname = name
                    }
                    if let email = (dict.object(forKey: "email") as? String) {
                        currentUser.email = email
                    }
//                    if let picture = (dict.object(forKey: "picture") as? NSDictionary) {
//                        if let data = picture.object(forKey: "data") as? NSDictionary {
//                            if let url = data.object(forKey: "url") as? String {
//                                currentUser.avatar = url
//                            }
//                        }
//                    }
                    DispatchQueue.global(qos: .background).async {
                        let response = appDelegate.services.facebookLogin(user: currentUser)
                        DispatchQueue.main.async {
                            if response?.status == ResponseStatus.SUCCESS.rawValue {
                                if let json = response?.json?.first {
                                    if let jsonUser = json["user"] as? NSDictionary {
                                        if let user = User.init(dictionary: jsonUser) {
                                            currentUser = user
                                            
                                            self.saveUserInUserDefaults()
                                            self.navigateToHome()
                                            
//                                            if currentUser.avatar == nil {
//                                                self.redirectToVC(storyboardId: StoryboardIds.SignupViewController, type: .push)
//                                            } else {
//                                                self.navigateToHome()
//                                            }
                                        }
                                    }
                                }
                            } else {
                                if let message = response?.message {
                                    self.showAlertView(message: message, doneTitle: "Ok")
                                }
                            }
                            
                            self.hideLoader()
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.hideLoader()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.hideLoader()
                }
            }
        })
    }
    
    func setupDelegates() {
        self.textFieldEmail.delegate = self
        self.textFieldPassword.delegate = self
        self.scrollView.delegate = self
    }
    
    var errorMessage: String!
    func isValidData() -> Bool {
        errorMessage = textFieldEmail.validate(validationType: .Regex, fieldType: .Email)
        if !errorMessage.isEmpty {
            return false
        }
        errorMessage = textFieldPassword.validate(fieldType: .Password)
        if !errorMessage.isEmpty {
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldEmail {
            textFieldPassword.becomeFirstResponder()
        } else {
            self.dismissKeyboard()
        }
        
        return true
    }
    
    @objc func navigateToHome() {
        if isAppActive {
            self.redirectToVC(storyboardId: StoryboardIds.MainNavigationController, type: .present)
        } else {
            DispatchQueue.main.async {
                self.goToYoutubeNavigation()
            }
        }
    }
    
    @objc func navigateToAdmin() {
        self.redirectToVC(storyboard: adminStoryboard, storyboardId: StoryboardIds.AdminNavigationController, type: .present)
    }
    
    @IBAction func buttonPrivacyTapped(_ sender: Any) {
        WebViewController.comingFrom = .Privacy
        self.redirectToVC(storyboardId: StoryboardIds.WebViewController, type: .present)
    }
    
    @IBAction func buttonTermsTapped(_ sender: Any) {
        WebViewController.comingFrom = .Terms
        self.redirectToVC(storyboardId: StoryboardIds.WebViewController, type: .present)
    }
    
    func goToYoutubeNavigation() {
        self.redirectToVC(storyboardId: StoryboardIds.YoutubePlayerViewController, type: .present)
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
