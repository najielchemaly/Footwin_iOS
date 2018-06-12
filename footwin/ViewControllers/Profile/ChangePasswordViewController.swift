//
//  ChangePasswordViewController.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/10/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit

class ChangePasswordViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var viewOldPassword: UIView!
    @IBOutlet weak var viewNewPassword: UIView!
    @IBOutlet weak var viewConfirmPassword: UIView!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var textFieldOldPassword: UITextField!
    @IBOutlet weak var textFieldNewPassword: UITextField!
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    
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
    
    func initializeViews() {
        viewOldPassword.customizeBorder(color: Colors.white)
        viewNewPassword.customizeBorder(color: Colors.white)
        viewConfirmPassword.customizeBorder(color: Colors.white)
    }
    
    func setupDelegates() {
        textFieldOldPassword.delegate = self
        textFieldNewPassword.delegate = self
        textFieldConfirmPassword.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldOldPassword {
            textFieldNewPassword.becomeFirstResponder()
        } else if textField == textFieldNewPassword {
            textFieldConfirmPassword.becomeFirstResponder()
        } else {
            self.dismissKeyboard()
        }
        
        return true
    }
    
    var errorMessage: String!
    func isValidData() -> Bool {
        errorMessage = textFieldOldPassword.validate(fieldType: .Password)
        if !errorMessage.isEmpty {
            return false
        }
        errorMessage = textFieldNewPassword.validate(fieldType: .Password)
        if !errorMessage.isEmpty {
            return false
        }
        errorMessage = textFieldNewPassword.validate(validationType: .Passwords, fieldType: .Password, password: textFieldConfirmPassword.text!)
        if !errorMessage.isEmpty {
            return false
        }
        
        return true
    }
    
    func resetFields() {
        textFieldOldPassword.text = nil
        textFieldNewPassword.text = nil
        textFieldConfirmPassword.text = nil
    }
    
    @IBAction func buttonSaveTapped(_ sender: Any) {
        if isValidData() {
            self.showLoader()
            
            let oldPassword = textFieldOldPassword.text
            let newPassword = textFieldNewPassword.text
            let userId = currentUser.id
            
            DispatchQueue.global(qos: .background).async {
                let response = appDelegate.services.changePassword(id: userId!, oldPassword: oldPassword!, newPassword: newPassword!)
                
                DispatchQueue.main.async {
                    if response?.status == ResponseStatus.SUCCESS.rawValue {
                        self.showAlertView(title: "CHANGE PASSWORD", message: "Your password has been changed successfully")
                        self.alertView.buttonDone.addTarget(self, action: #selector(self.dismissVC), for: .touchUpInside)
                    } else {
                        if let message = response?.message {
                            self.showAlertView(message: message)
                        }
                    }
                    
                    self.resetFields()
                    self.hideLoader()
                }
            }
        } else {
            self.showAlertView(message: errorMessage)
        }
    }
    
    @IBAction func buttonCancelTapped(_ sender: Any) {
        self.dismissVC()
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
