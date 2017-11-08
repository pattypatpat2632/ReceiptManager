//
//  IAProduct.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 11/6/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation
import StoreKit

public class IAPConsumable: IAProtocol {
    var purchased = false
    let quantity: Int = 0
    var type: IAPType = .consumable
    
    var skProduct: SKProduct
    
    init(skProduct: SKProduct) {
        self.skProduct = skProduct
    }
}










