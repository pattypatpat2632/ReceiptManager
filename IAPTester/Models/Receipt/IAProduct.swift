//
//  IAProduct.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 11/6/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation
import StoreKit

class IAProduct: SKProduct {
    var purchased: Bool
    var sandbox: Bool
    let type: IAProductType
    let quantity: Int
    let purchaseDate: Date
    let expirationDate: Date
    let expirationIntent: ExpirationIntent?
    let autoRenew: Bool
    
    enum ExpirationIntent {
        case customerCancelled //Customer cancelled a subscription
        case billingError //EG Payment Information was no longer valid
        case priceIncrease //If the customer didn't agree to a price increase
        case unavailable //Product was not available at the time of renewal
        case unknown // Unknown
    }
    
    
    init(purchased: Bool) {
        super.init()
        
    }
}

enum IAProductType {
    case subscription
    case consumable
    case nonConsumable
}

