//
//  LeaderboardTableViewCell.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/16/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelRank: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelCoins: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
