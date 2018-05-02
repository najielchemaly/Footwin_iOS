//
//  ExactScoreView.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/13/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit

class ExactScoreView: UIView {

    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var labelHome: UILabel!
    @IBOutlet weak var textFieldHome: UITextField!
    @IBOutlet weak var awayImage: UIImageView!
    @IBOutlet weak var labelAway: UILabel!
    @IBOutlet weak var textFieldAway: UITextField!
    @IBOutlet weak var buttonConfirm: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var stackHeightConstraint: NSLayoutConstraint!
    
    var stackViewOriginalY: CGFloat = 0
    
    @IBAction func buttonCancelTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }, completion: { success in
            self.removeFromSuperview()
            
            NotificationCenter.default.removeObserver(self)
        })
    }
    
    func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        self.stackViewOriginalY = self.stackHeightConstraint.constant
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.addGestureRecognizer(tap)
                
        self.buttonConfirm.addTarget(self, action: #selector(self.buttonConfirmTapped), for: .touchUpInside)
    }
    
    @objc func buttonConfirmTapped(sender: UIButton) {
        if !textFieldHome.isEmpty() && !textFieldAway.isEmpty() {
            if let optionViewController = currentVC as? OptionViewController {
                optionViewController.matches[sender.tag].home_score = textFieldHome.text
                optionViewController.matches[sender.tag].away_score = textFieldAway.text
            } else {
                Objects.matches[sender.tag].home_score = textFieldHome.text
                Objects.matches[sender.tag].away_score = textFieldAway.text
                
                if let predictViewController = currentVC as? PredictViewController {
                    if let home_score = Double(textFieldHome.text!), let away_score = Double(textFieldAway.text!) {
                        if home_score > away_score && Objects.matches[sender.tag].winning_team != "home" {
                            predictViewController.homeTeamSelected(row: sender.tag)
                        } else if home_score < away_score && Objects.matches[sender.tag].winning_team != "away" {
                            predictViewController.awayTeamSelected(row: sender.tag)
                        } else if home_score == away_score && Objects.matches[sender.tag].winning_team != "draw" {
                            predictViewController.drawSelected(row: sender.tag)
                        }
                    }
                }
            }
            
            buttonCancelTapped(buttonCancel)
        } else {
            if let predictViewController = currentVC as? PredictViewController {
                predictViewController.showAlertView(title: "WOW", message: "ARE YOU SURE YOU WANT TO LEAVE WITHOUT SETTING EXACT SCORE?", cancelTitle: "CANCEL", doneTitle: "LEAVE")
                
                predictViewController.alertView.buttonDone.tag = sender.tag
                predictViewController.alertView.buttonDone.addTarget(self, action: #selector(self.leaveWithoutSettingExactScores(sender:)), for: .touchUpInside)
            }
        }
    }
    
    @objc func leaveWithoutSettingExactScores(sender: UIButton) {
        if let optionViewController = currentVC as? OptionViewController {
            optionViewController.matches[sender.tag].home_score = nil
            optionViewController.matches[sender.tag].away_score = nil
        } else {
            Objects.matches[sender.tag].home_score = nil
            Objects.matches[sender.tag].away_score = nil
        }
        
        buttonCancelTapped(buttonCancel)
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
        
        self.stackHeightConstraint.constant = self.stackViewOriginalY
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        })
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if textFieldHome.isFirstResponder || textFieldAway.isFirstResponder {
            if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                
                self.stackHeightConstraint.constant -= (keyboardRectangle.height/2)+20
                UIView.animate(withDuration: 0.3, animations: {
                    self.layoutIfNeeded()
                })
            }
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
