//
//  CoinProducts.swift
//  footwin
//
//  Created by MR.CHEMALY on 4/22/18.
//  Copyright © 2018 we-devapp. All rights reserved.
//

import Foundation

public struct CoinProducts {

//    private static let bundleItendifier = "com.we-devapp.footwin"
    private static let bundleItendifier = ""
    
    public static let starterPack = CoinProducts.bundleItendifier + "com.footwin.starterpack"
    public static let hatTrickPack = CoinProducts.bundleItendifier + "com.footwin.hattrickpack"
    public static let halfTimePack = CoinProducts.bundleItendifier + "com.footwin.halftimepack"
    public static let superHatTrickPack = CoinProducts.bundleItendifier + "com.footwin.superhattrickpack"
    public static let footwinSpecialPack = CoinProducts.bundleItendifier + "com.footwin.footinwspecialpack"
    public static let jokerPack = CoinProducts.bundleItendifier + "com.footwin.jokerpack"
    
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
