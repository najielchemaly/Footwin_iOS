//
//  TutorialView.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/12/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit

class TutorialView: UIView {

    @IBOutlet weak var viewNotif: UIView!
    @IBOutlet weak var viewRules: UIView!
    @IBOutlet weak var viewPredict: UIView!
    @IBOutlet weak var viewExactScore: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var viewCoins: UIView!
    
    @IBAction func buttonNextTapped(_ sender: Any) {
        if buttonNext.tag == 1 {
            labelTitle.text = "COIN STASH"
            labelDescription.text = "TAP ON THE YELLO COIN TO CHECK YOUR BALANCE, AND GET MORE WHENEVER YOU ARE OUT OF COINS"
            
            UIView.animate(withDuration: 0.1, animations: {
                self.viewNotif.alpha = 0
            }, completion: { success in
                UIView.animate(withDuration: 0.5, animations: {
                    self.viewCoins.alpha = 1
                })
            })
            
            buttonNext.tag += 1
        } else if buttonNext.tag == 2 {
            labelTitle.text = "VIEW RULES"
            labelDescription.text = "TAP ON THE 'VIEW RULES' BUTTON TO CHECK THE ROUND RULES"
            
            UIView.animate(withDuration: 0.1, animations: {
                self.viewCoins.alpha = 0
            }, completion: { success in
                UIView.animate(withDuration: 0.5, animations: {
                    self.viewRules.alpha = 1
                })
            })
            
            buttonNext.tag += 1
        } else if buttonNext.tag == 3 {
            labelTitle.text = "PREDICTION"
            labelDescription.text = "TAP ON THE TEAM ICON TO PREDICT THE WINNER TEAM"
            
            UIView.animate(withDuration: 0.1, animations: {
                self.viewRules.alpha = 0
            }, completion: { success in
                UIView.animate(withDuration: 0.5, animations: {
                    self.viewPredict.alpha = 1
                })
            })
            
            buttonNext.tag += 1
        } else if buttonNext.tag == 4 {
            labelTitle.text = "EXACT SCORE"
            labelDescription.text = "TAP HERE TO PREDICT THE EXACT SCORE AND INCREASE YOUR WINNING COINS"
            
            UIView.animate(withDuration: 0.1, animations: {
                self.viewPredict.alpha = 0
            }, completion: { success in
                UIView.animate(withDuration: 0.5, animations: {
                    self.viewExactScore.alpha = 1
                })
            })
            
            buttonNext.tag += 1
            buttonNext.setTitle("GET STARTED", for: .normal)
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            }, completion: { success in
                self.removeFromSuperview()
            })
        }
    }
    
    func showFirstTutorial() {
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut, animations: {
            self.viewNotif.alpha = 1
        }, completion: nil)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
