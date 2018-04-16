//
//  PredictTableViewCell.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/13/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit

class PredictionTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTimeTitle: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var homeShadow: UIImageView!
    @IBOutlet weak var labelHome: UILabel!
    @IBOutlet weak var awayImage: UIImageView!
    @IBOutlet weak var awayShadow: UIImageView!
    @IBOutlet weak var labelAway: UILabel!
    @IBOutlet weak var labelVS: UILabel!
    @IBOutlet weak var buttonDraw: UIButton!
    @IBOutlet weak var viewExactScore: UIView!
    @IBOutlet weak var viewConfirm: UIView!
    @IBOutlet weak var awayWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var awayShadowWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var homeWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var homeShadowWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelConfirm: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        buttonDraw.customizeBorder(color: Colors.white)
        viewConfirm.layer.cornerRadius = viewConfirm.frame.size.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
