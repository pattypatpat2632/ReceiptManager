//
//  IAPAutoSubscription.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 11/8/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation
import StoreKit

public class IAPAutoSubscription: IAProduct {
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
    
    override init(with skProduct: SKProduct, receipt: Receipt?, pendingRenewal: PendingRenewal?) {
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
