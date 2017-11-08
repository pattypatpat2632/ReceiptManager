//
//  IAProtocol.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 11/8/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation
import StoreKit

// A super class for all of the iaproduct types
public class IAProduct {
    var purchased: Bool
    
    var skProduct: SKProduct
    
    var localizedDesciption: String {
        return skProduct.localizedDescription
    }
    var localizedTitle: String {
        return skProduct.localizedTitle
    }
    var price: Double {
        return skProduct.price.doubleValue
    }
    var priceLocale: Locale {
        return skProduct.priceLocale
    }
    var productID: String {
        return skProduct.productIdentifier
    }
    var isDownloadable: Bool {
        return skProduct.isDownloadable
    }
    var downloadContentLengths: [NSNumber] {
        return skProduct.downloadContentLengths
    }
    var downloadContentVersion: String {
        return skProduct.downloadContentVersion
    }
    
    var type: IAPType
    
    init(purchased: Bool, skProduct: SKProduct, type: IAPType) {
        self.purchased = purchased
        self.skProduct = skProduct
        self.type = type
    }
}

// Enum representing each type of in-app purchase
public enum IAPType {
    case subscription
    case autoSubscription
    case nonConsumable
    case consumable
}

// A class used to represent the information created by a user in the iTunes Connect
// Can either be entered manually, or loaded in from a database
// Will hopefully build extensions for communicating with database
public class IAPStoreInfo {
    let type: IAPType
    let productID: String
    
    init(type: IAPType, productID: String) {
        self.type = type
        self.productID = productID
    }
}
