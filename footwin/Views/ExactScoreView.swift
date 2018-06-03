//
//  ExactScoreView.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/13/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit

class ExactScoreView: UIView, UIScrollViewDelegate {

    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var labelHome: UILabel!
    @IBOutlet weak var textFieldHome: UITextField!
    @IBOutlet weak var awayImage: UIImageView!
    @IBOutlet weak var labelAway: UILabel!
    @IBOutlet weak var textFieldAway: UITextField!
    @IBOutlet weak var buttonConfirm: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var stackHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
        
        self.scrollView.delegate = self
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > 0 || scrollView.contentOffset.x < 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    @objc func buttonConfirmTapped(sender: UIButton) {
        if !textFieldHome.isEmpty() && !textFieldAway.isEmpty() {
            if let optionViewController = currentVC as? OptionViewController {
                optionViewController.matches[sender.tag].home_score = textFieldHome.text
                optionViewController.matches[sender.tag].away_score = textFieldAway.text
            } else {
                Objects.matches[sender.tag].prediction_home_score = textFieldHome.text
                Objects.matches[sender.tag].prediction_away_score = textFieldAway.text
                
                if let predictViewController = currentVC as? PredictViewController {
                    if let prediction_home_score = Double(textFieldHome.text!), let prediction_away_score = Double(textFieldAway.text!) {
                        let match = Objects.matches[sender.tag]
                        if prediction_home_score > prediction_away_score && match.prediction_winning_team != match.home_id {
                            predictViewController.homeTeamSelected(row: sender.tag, resetScores: false)
                        } else if prediction_home_score < prediction_away_score && match.prediction_winning_team != match.away_id {
                            predictViewController.awayTeamSelected(row: sender.tag, resetScores: false)
                        } else if prediction_home_score == prediction_away_score && match.prediction_winning_team != "0" {
                            predictViewController.drawSelected(row: sender.tag, resetScores: false)
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
            optionViewController.matches[sender.tag].prediction_home_score = "-1"
            optionViewController.matches[sender.tag].prediction_away_score = "-1"
        } else {
            Objects.matches[sender.tag].prediction_home_score = "-1"
            Objects.matches[sender.tag].prediction_away_score = "-1"
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
