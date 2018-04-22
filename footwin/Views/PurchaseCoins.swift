//
//  PurchaseCoins.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/15/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit
import FSPagerView
import StoreKit

class PurchaseCoins: UIView, FSPagerViewDataSource, FSPagerViewDelegate {

    @IBOutlet weak var pagerView: FSPagerView!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var pagerHeightConstraint: NSLayoutConstraint!
    
    var products = [SKProduct]()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func setupPagerView() {
        self.pagerView.transformer = FSPagerViewTransformer(type: .linear)
        self.pagerView.register(UINib.init(nibName: CellIds.PurchaseCoinsViewCell, bundle: nil), forCellWithReuseIdentifier: CellIds.PurchaseCoinsViewCell)
        
        let itemSize = self.pagerView.frame.size.width*0.9
        self.pagerView.itemSize = CGSize(width: itemSize, height: itemSize*1.1)
        pagerHeightConstraint.constant = itemSize*1.1
        
        self.pagerView.dataSource = self
        self.pagerView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(PurchaseCoins.handlePurchaseNotification(_:)),
                                               name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification),
                                               object: nil)
        
        self.reloadProducts()
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        if let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CellIds.PurchaseCoinsViewCell, at: index) as? PurchaseCoinsViewCell {
            
            let package = Objects.packages[index]
            
            if let title = package.title {
                cell.labelTitle.text = title
            }
            if let coins = package.coins {
                cell.labelCoins.text = coins + " COINS"
            }
            if let desc = package.desc {
                cell.labelDescription.text = desc
            }
            if let price = package.price {
                cell.labelPrice.text = price + "$"
            }
            
            cell.buttonPurchase.layer.borderColor = Colors.appBlue.cgColor
            cell.buttonPurchase.layer.borderWidth = 1.0
            
            cell.contentView.layer.shadowRadius = 0
            cell.backgroundColor = .clear
            cell.layer.cornerRadius = 20
            
            return cell
        }
        
        return FSPagerViewCell()
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return Objects.packages.count
    }
    
    func reloadProducts() {
        products = []
        
//        tableView.reloadData()
        
        CoinProducts.store.requestProducts{success, products in
            if success {
                self.products = products!
                
//                self.tableView.reloadData()
            }
            
//            self.refreshControl?.endRefreshing()
        }
    }
    
    func restoreTapped(_ sender: AnyObject) {
        CoinProducts.store.restorePurchases()
    }
    
    @objc func handlePurchaseNotification(_ notification: NSNotification) {
        guard let productID = notification.object as? String else { return }
        
        for (index, product) in products.enumerated() {
            guard product.productIdentifier == productID else { continue }
            
//            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        }
    }

    @IBAction func buttonCloseTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }, completion: { success in
            self.removeFromSuperview()
        })
    }
    
}
