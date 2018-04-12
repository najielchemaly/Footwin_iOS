//
//  TeamCollectionViewCell.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/11/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit

class TeamCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var selectedTeamOverlay: UIImageView!
    @IBOutlet weak var selectedCheckmark: UIImageView!
    @IBOutlet weak var labelTeamName: UILabel!
    @IBOutlet weak var imageTeam: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
