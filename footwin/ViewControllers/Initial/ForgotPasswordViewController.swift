//
//  ForgotPasswordViewController.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var buttonResetPassword: UIButton!
    @IBOutlet weak var buttonClose: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupDelegates()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonResetPasswordTapped(_ sender: Any) {
        if isValidData() {
            self.showLoader()
            
            let email = self.textFieldEmail.text
            DispatchQueue.global(qos: .background).async {
                let response = appDelegate.services.forgotPassword(email: email!)
                
                DispatchQueue.main.async {
                    var alertTitle: String? = nil
                    if response?.status == ResponseStatus.SUCCESS.rawValue {
                        alertTitle = "WOW!"
                        
//                        self.alertView.buttonDone.addTarget(self, action: #selector(self.dismissVC), for: .touchUpInside)
                    }
                    
                    if let message = response?.message {
//                        self.showAlertView(title: alertTitle, message: message)
                    }
                    
                    self.hideLoader()
                }
            }
        } else {
//            self.showAlertView(message: errorMessage)
        }
    }
    
    @IBAction func buttonCloseTapped(_ sender: Any) {
        self.dismissVC()
    }
    
    func setupDelegates() {
        self.textFieldEmail.delegate = self
    }
    
    var errorMessage: String!
    func isValidData() -> Bool {
        if textFieldEmail.text == nil || textFieldEmail.text == "" {
            errorMessage = "Email field cannot be empty"
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == textFieldEmail {
            self.dismissKeyboard()
        }
        
        return true
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
