//
//  IAPSubscription.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 11/8/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation
import StoreKit

public class IAPSubscription: IAProtocol {
    
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
