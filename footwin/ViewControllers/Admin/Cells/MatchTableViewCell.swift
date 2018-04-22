//
//  MatchTableViewCell.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/21/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit

class MatchTableViewCell: UITableViewCell {

    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var labelHome: UILabel!
    @IBOutlet weak var awayImage: UIImageView!
    @IBOutlet weak var labelAway: UILabel!
    @IBOutlet weak var labelVS: UILabel!
    @IBOutlet weak var buttonDraw: UIButton!
    @IBOutlet weak var viewExactScore: UIView!
    @IBOutlet weak var viewSubmit: UIView!
    @IBOutlet weak var imageCheck: UIImageView!
    @IBOutlet weak var labelSubmit: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
