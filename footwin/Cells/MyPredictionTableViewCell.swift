//
//  MyPredictionTableViewCell.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/17/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit
import CountdownLabel

class MyPredictionTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: CountdownLabel!
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var homeShadow: UIImageView!
    @IBOutlet weak var labelHome: UILabel!
    @IBOutlet weak var labelHomeScore: UILabel!
    @IBOutlet weak var awayImage: UIImageView!
    @IBOutlet weak var awayShadow: UIImageView!
    @IBOutlet weak var labelAway: UILabel!
    @IBOutlet weak var labelAwayScore: UILabel!
    @IBOutlet weak var labelVS: UILabel!
    @IBOutlet weak var buttonDraw: UIButton!
    @IBOutlet weak var viewConfirm: UIView!
    @IBOutlet weak var topBarImageView: UIImageView!
    @IBOutlet weak var viewConfirmWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewWinningCoins: UIStackView!
    @IBOutlet weak var labelWinningCoins: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
