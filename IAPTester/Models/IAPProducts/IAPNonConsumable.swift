//
//  IAPNonConsumable.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 11/8/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation
import StoreKit

// Model representing a non-consumable In-App Purchase
public class IAPNonConsumable: IAProduct {
    
    let quantity: Int

    init(skProduct: SKProduct, receipts: [Receipt]?) {
        var purchased: Bool
        if let receipts = receipts{
            purchased = true
            var quantity: Int = 0
            for quantityValue in receipts.map({$0.quantity}) {
                if let quantityValue = Int(quantityValue) {
                    quantity += quantityValue
                }
            }
            self.quantity = quantity
        } else {
            purchased = false
            self.quantity = 0
        }
        super.init(purchased: purchased, skProduct: skProduct, type: .nonConsumable)
    }
}
