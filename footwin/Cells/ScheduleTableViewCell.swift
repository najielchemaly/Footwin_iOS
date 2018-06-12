//
//  ScheduleTableViewCell.swift
//  footwin
//
//  Created by MR.CHEMALY on 6/11/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit
import CountdownLabel

class ScheduleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTimeTitle: UILabel!
    @IBOutlet weak var labelTime: CountdownLabel!
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var labelHome: UILabel!
    @IBOutlet weak var awayImage: UIImageView!
    @IBOutlet weak var labelAway: UILabel!
    @IBOutlet weak var labelVS: UILabel!
    @IBOutlet weak var awayWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var homeWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewTime: UIStackView!
    @IBOutlet weak var labelDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
