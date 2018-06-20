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
    
    var buyButtonHandler: ((_ product: SKProduct) -> ())?
    
    var product: SKProduct? {
        didSet {
            guard let product = product else { return }
            
            textLabel?.text = product.localizedTitle
            
            if CoinProducts.store.isProductPurchased(product.productIdentifier) {
               
            } else {
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupButtonPurchase() {
        self.buttonPurchase.addTarget(self, action: #selector(buttonPurchaseTapped(sender:)), for: .touchUpInside)
    }
    
    @objc func buttonPurchaseTapped(sender: UIButton) {
        buyButtonHandler?(product!)
    }

}
