//
//  PurchaseCoinsViewCell.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/15/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit
import FSPagerView
import StoreKit

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
    
    func setupButtonPurchase() {
        self.buttonPurchase.layer.borderColor = Colors.appBlue.cgColor
        self.buttonPurchase.layer.borderWidth = 1.0
        self.buttonPurchase.addTarget(self, action: #selector(buttonPurchaseTapped(sender:)), for: .touchUpInside)
    }
    
    @objc func buttonPurchaseTapped(sender: UIButton) {
        if let coinStashViewController = currentVC as? CoinStashViewController {
            coinStashViewController.buttonPurchaseTapped(index: sender.tag)
        }
        else if let predictViewController = currentVC as? PredictViewController {
            predictViewController.buttonPurchaseTapped(index: sender.tag)
        }
    }

}
