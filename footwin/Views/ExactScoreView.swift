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
    
    @IBAction func buttonCancelTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }, completion: { success in
            self.removeFromSuperview()
        })
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
