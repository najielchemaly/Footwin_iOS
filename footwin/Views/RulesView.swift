//
//  RulesView.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/13/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit

class RulesView: UIView {

    @IBOutlet weak var labelPredict: UILabel!
    @IBOutlet weak var labelWin: UILabel!
    @IBOutlet weak var labelExactScore: UILabel!
    @IBOutlet weak var buttonClose: UIButton!
    
    @IBAction func buttonCloseTapped(_ sender: Any) {
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
