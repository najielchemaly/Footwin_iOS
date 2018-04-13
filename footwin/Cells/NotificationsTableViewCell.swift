//
//  NotificationsTableViewCell.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/13/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageNew: UIImageView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var buttonGetCoins: UIButton!
    @IBOutlet weak var viewMatchResult: UIView!
    @IBOutlet weak var imageHome: UIImageView!
    @IBOutlet weak var labelHome: UILabel!
    @IBOutlet weak var imageAway: UIImageView!
    @IBOutlet weak var labelAway: UILabel!
    @IBOutlet weak var labelResult: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonGetCoinsTapped(_ sender: Any) {
        
    }
    
}
