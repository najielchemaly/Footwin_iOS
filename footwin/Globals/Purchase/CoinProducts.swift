//
//  CoinProducts.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/22/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import Foundation

public struct CoinProducts {

    public static let starterPack = "com.footwin.starterpack"
    public static let hatTrickPack = "com.footwin.hattrickpack"
    public static let halfTimePack = "com.footwin.halftimepack"
    public static let superHatTrickPack = "com.footwin.superhattrickpack"
    public static let footwinSpecialPack = "com.footwin.footinwspecialpack"
    public static let jokerPack = "com.footwin.jokerpack"
    
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [
        CoinProducts.starterPack,
        CoinProducts.hatTrickPack,
        CoinProducts.halfTimePack,
        CoinProducts.superHatTrickPack,
        CoinProducts.footwinSpecialPack,
        CoinProducts.jokerPack
    ]
    
    public static let store = IAPHelper(productIds: CoinProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
