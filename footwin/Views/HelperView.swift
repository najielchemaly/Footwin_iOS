//
//  HelperView.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/12/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit

class HelperView: UIView {

    @IBOutlet weak var buttonStartTutorial: UIButton!    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var textViewDesc: UITextView!
    
    @IBAction func buttonTermsTapped(_ sender: Any) {
        if let baseVC = currentVC as? BaseViewController, let helperView = baseVC.customView as? HelperView {
            helperView.alpha = 0
            WebViewController.comingFrom = .Terms
            baseVC.redirectToVC(storyboardId: StoryboardIds.WebViewController, type: .present)
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
