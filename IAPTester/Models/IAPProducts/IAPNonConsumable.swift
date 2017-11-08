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
public class IAPNonConsumable: IAProtocol {
    
    var purchased: Bool
    let quantity: Int
    var type: IAPType = .nonConsumable
    var skProduct: SKProduct
    
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
