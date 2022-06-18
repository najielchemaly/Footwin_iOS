//
//  IAP.swift
//  footwin
//
//  Created by MR.CHEMALY on 6/25/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import UIKit
import StoreKit

enum IAPHandlerAlertType{
    case disabled
    case restored
    case purchased
    
    func message() -> String{
        switch self {
        case .disabled: return "Purchases are disabled in your device!"
        case .restored: return "You've successfully restored your purchase!"
        case .purchased: return "You've successfully bought this purchase!"
        }
    }
}

class IAPHandler: NSObject {
    static let shared = IAPHandler()
    
    private static let bundleItendifier = ""
    
    let starterPack = IAPHandler.bundleItendifier + "com.footwin.starterpack"
    let hatTrickPack = IAPHandler.bundleItendifier + "com.footwin.hattrickpack"
    let halfTimePack = IAPHandler.bundleItendifier + "com.footwin.halftimepack"
    let superHatTrickPack = IAPHandler.bundleItendifier + "com.footwin.superhattrickpack"
    let footwinSpecialPack = IAPHandler.bundleItendifier + "com.footwin.footwinspecialpack"
    
    fileprivate var productID = ""
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var iapProducts = [SKProduct]()
    
    var purchaseStatusBlock: ((IAPHandlerAlertType) -> Void)?
    
    // MARK: - MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    static var selectedIndex = 0
    func purchaseMyProduct(index: Int){
        if iapProducts.count == 0 { return }
        
        if self.canMakePurchases() {
            let product = iapProducts[index]
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            print("PRODUCT TO PURCHASE: \(product.productIdentifier)")
            productID = product.productIdentifier
            
            IAPHandler.selectedIndex = index
        } else {
            purchaseStatusBlock?(.disabled)
        }
    }
    
    // MARK: - RESTORE PURCHASE
    func restorePurchase(){
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    // MARK: - FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts(){
        
        // Put here your IAP Products ID's
        let productIdentifiers = NSSet(objects:
            starterPack, hatTrickPack, halfTimePack, superHatTrickPack, footwinSpecialPack
        )
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
}

extension IAPHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver{
    // MARK: - REQUEST IAP PRODUCTS
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        
        if (response.products.count > 0) {
            iapProducts = response.products.sorted(by: {
                $0.price.decimalValue < $1.price.decimalValue
            })
            for product in iapProducts{
                let numberFormatter = NumberFormatter()
                numberFormatter.formatterBehavior = .behavior10_4
                numberFormatter.numberStyle = .currency
                numberFormatter.locale = product.priceLocale
                let price1Str = numberFormatter.string(from: product.price)
                print(product.localizedDescription + "\nfor just \(price1Str!)")
            }
            
            if let baseVC = currentVC as? BaseViewController {
                baseVC.hideLoader()
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        purchaseStatusBlock?(.restored)
    }
    
    // MARK:- IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    print("purchased")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    purchaseStatusBlock?(.purchased)
                    
                    DispatchQueue.global(qos: .background).async {
                        let package = Objects.packages[IAPHandler.selectedIndex]
                        let response = appDelegate.services.purchaseCoins(id: package.id!, amount: package.coins!)
                        
                        if let baseVC = currentVC as? BaseViewController {
                            DispatchQueue.main.async {
                                if response?.status == ResponseStatus.SUCCESS.rawValue {
                                    if let json = response?.json?.first {
                                        if let coins = json["coins"] as? String {
                                            currentUser.coins = coins
                                            baseVC.saveUserInUserDefaults()
                                            
                                            if let coinsStashVC = currentVC as? CoinStashViewController {
                                                coinsStashVC.labelTotalCoins.text = coins
                                            }
                                            else if let predictVC = currentVC as? PredictViewController {
                                                predictVC.labelCoins.text = coins
                                            }
                                        }
                                    }
                                    
                                    if let message = response?.message {
                                        baseVC.showAlertView(message: message)
                                    }
                                }
                                
                                baseVC.hideLoader()
                            }
                        }
                    }
                    
                    break
                case .failed:
                    print("failed")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    if let baseVC = currentVC as? BaseViewController {
                        baseVC.hideLoader()
                    }
                    break
                case .restored:
                    print("restored")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    if let baseVC = currentVC as? BaseViewController {
                        baseVC.hideLoader()
                    }
                    break
                default:
                    if let baseVC = currentVC as? BaseViewController {
                        baseVC.showLoader()
                    }
                    break
                }}}
    }
}
