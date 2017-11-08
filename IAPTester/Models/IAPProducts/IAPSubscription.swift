//
//  IAPSubscription.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 11/8/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation
import StoreKit

public class IAPSubscription: IAProduct {
    
    var purchaseDate: Date?
    var expirationDate: Date?
    
    var subscribed: Bool {
        if let expirationDate = expirationDate {
            return Date() <= expirationDate
        } else {
            return false
        }
    }
    
    init(with skProduct: SKProduct, receipt: Receipt?) {
        var purchased: Bool
        
        if let receipt = receipt {
            purchased = true
            
            if let expirationDate = receipt.expirationDate, let purchaseDate = receipt.purchaseDate {
                self.expirationDate = Date(timeIntervalSince1970: expirationDate / 1000)
                self.purchaseDate = Date(timeIntervalSince1970: purchaseDate / 1000)
            }
        } else {
            purchased = false
        }
        super.init(purchased: purchased, skProduct: skProduct, type: .subscription)
    }
}
