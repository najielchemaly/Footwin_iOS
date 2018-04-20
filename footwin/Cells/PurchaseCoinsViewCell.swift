//
//  PurchaseCoinsViewCell.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/15/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit
import FSPagerView

class PurchaseCoinsViewCell: FSPagerViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelCoins: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var buttonPurchase: UIButton!
    @IBOutlet weak var labelPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
