//
//  IAProduct.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 11/6/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation
import StoreKit

class IAPConsumable: IAProtocol {
    var purchased = false
    let quantity: Int = 0
    var type: IAPType = .consumable
    
    var skProduct: SKProduct
    
    init(skProduct: SKProduct) {
        self.skProduct = skProduct
    }
}

class IAPNonConsumable: IAProtocol {

    var purchased: Bool
    var skProduct: SKProduct
    let quantity: Int
    var type: IAPType = .nonConsumable
    
    init(skProduct: SKProduct, receipts: [Receipt]?) {
        self.skProduct = skProduct
        if let receipts = receipts{
            self.purchased = true
            var quantity: Int = 0
            for quantityValue in receipts.map({$0.quantity}) {
                if let quantityValue = Int(quantityValue) {
                    quantity += quantityValue
                }
            }
            self.quantity = quantity
        } else {
            self.purchased = false
            self.quantity = 0
        }
    }
}

class IAPAutoSubscription: IAProtocol {
    var purchased: Bool
    var skProduct: SKProduct
    var purchaseDate: Date?
    var expirationDate: Date?
    var expirationIntent: ExpirationIntent?
    var type: IAPType = .autoSubscription
    
    var subscribed: Bool {
        if let expirationDate = expirationDate {
            return Date() <= expirationDate
        } else {
            return false
        }
    }
    
    init(with skProduct: SKProduct, receipt: Receipt?, pendingRenewal: PendingRenewal?) {
        self.skProduct = skProduct
        
        if let receipt = receipt {
            self.purchased = true
            
            if let expirationDate = receipt.expirationDate, let purchaseDate = receipt.purchaseDate {
                self.expirationDate = Date(timeIntervalSince1970: expirationDate / 1000)
                self.purchaseDate = Date(timeIntervalSince1970: purchaseDate / 1000)
            }
        } else {
            self.purchased = false
        }
        
        if let pR = pendingRenewal {
            self.expirationIntent = ExpirationIntent(rawValue: pR.expiration_intent)
        }
    }
    
    enum ExpirationIntent: String {
        case customerCancelled = "1" //Customer cancelled a subscription
        case billingError = "2" //EG Payment Information was no longer valid
        case priceIncrease = "3" //If the customer didn't agree to a price increase
        case unavailable = "4" //Product was not available at the time of renewal
        case unknown = "5" // Unknown
    }
    
}

class IAPSubscription: IAProtocol {
    
    var purchased: Bool
    var purchaseDate: Date?
    var expirationDate: Date?
    var skProduct: SKProduct
    var type: IAPType = .subscription
    
    var subscribed: Bool {
        if let expirationDate = expirationDate {
            return Date() <= expirationDate
        } else {
            return false
        }
    }
    
    init(with skProduct: SKProduct, receipt: Receipt?) {
        self.skProduct = skProduct
        
        if let receipt = receipt {
            self.purchased = true
            
            if let expirationDate = receipt.expirationDate, let purchaseDate = receipt.purchaseDate {
                self.expirationDate = Date(timeIntervalSince1970: expirationDate / 1000)
                self.purchaseDate = Date(timeIntervalSince1970: purchaseDate / 1000)
            }
        } else {
            self.purchased = false
        }
    }
}

protocol IAProtocol {
    var purchased: Bool {get}
    var productID: String {get}
    var skProduct: SKProduct {get}
    var localizedDesciption: String {get}
    var localizedTitle: String {get}
    var price: Double {get}
    var priceLocale: Locale {get}
    var isDownloadable: Bool {get}
    var downloadContentLengths: [NSNumber] {get}
    var downloadContentVersion: String {get}
    
    var type: IAPType {get}
}

extension IAProtocol {
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
}

enum IAPType {
    case subscription
    case autoSubscription
    case nonConsumable
    case consumable
}

class IAPStoreInfo {
    let type: IAPType
    let productID: String
    
    init(type: IAPType, productID: String) {
        self.type = type
        self.productID = productID
    }
}


