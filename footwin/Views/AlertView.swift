//
//  AlertView.swift
//  ramychemaly
//
//  Created by MR.CHEMALY on 3/8/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit

class AlertView: UIView {

    @IBOutlet weak var viewOverlay: UIView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonDone: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewCenterYConstraint: NSLayoutConstraint!
    
    @IBAction func buttonCancelTapped(_ sender: Any) {
        if let baseVC = currentVC as? BaseViewController {
            baseVC.hideAlertView()
        }
    }
    
    @IBAction func buttonDoneTapped(_ sender: Any) {
        if let baseVC = currentVC as? BaseViewController {
            baseVC.hideAlertView()
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
