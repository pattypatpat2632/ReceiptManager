//
//  IAProduct.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 11/6/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation
import StoreKit

class IANotPurchased: IAProduct {
    var purchased = false
    let quantity: Int = 0
    
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
    
    var skProduct: SKProduct
    
    init(skProduct: SKProduct) {
        self.skProduct = skProduct
    }
}

class IANonSubscription: IAProduct {
    var purchased: Bool
    let quantity: Int
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
    
    let skProduct: SKProduct
    
    init(skProduct: SKProduct, receipts: [Receipt]) {
        self.skProduct = skProduct
        self.purchased = true
        var quantity: Int = 0
        for quantityValue in receipts.map({$0.quantity}) {
            if let quantityValue = Int(quantityValue) {
                quantity += quantityValue
            }
        }
        self.quantity = quantity
    }
}

class IASubscription: IAProduct {
    var purchased: Bool
    
    let purchaseDate: Date
    let expirationDate: Date
    let expirationIntent: ExpirationIntent?
    let autoRenew: Bool
    var expired: Bool {
        return purchaseDate >= expirationDate
    }
    
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
    
    let skProduct: SKProduct
    
    init?(with skProduct: SKProduct, receipt: Receipt, pendingRenewal: PendingRenewal) {
        guard let expiresDateStr = receipt.expires_date_ms else {return nil}
        guard let purchaseDate = Double(receipt.original_purchase_date_ms), let expiresDate = Double(expiresDateStr) else {return nil}
        self.purchased = true
        self.purchaseDate = Date(timeIntervalSince1970: purchaseDate / 1000)
        self.expirationDate = Date(timeIntervalSince1970: expiresDate / 1000)
        self.expirationIntent = ExpirationIntent(rawValue: pendingRenewal.expiration_intent)
        self.autoRenew = true
        self.skProduct = skProduct
    }
    
}

protocol IAProduct {
    var purchased: Bool {get}
    var productID: String {get}
}

enum ExpirationIntent: String {
    case customerCancelled = "1" //Customer cancelled a subscription
    case billingError = "2" //EG Payment Information was no longer valid
    case priceIncrease = "3" //If the customer didn't agree to a price increase
    case unavailable = "4" //Product was not available at the time of renewal
    case unknown = "5" // Unknown
}

enum ProductType {
    case subscription
    case nonConsumable
    case consumable
}


