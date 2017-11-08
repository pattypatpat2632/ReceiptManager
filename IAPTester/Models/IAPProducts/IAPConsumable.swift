//
//  IAProduct.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 11/6/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation
import StoreKit

public class IAPConsumable: IAProduct {

    let quantity: Int = 0
    
    init(skProduct: SKProduct) {
        super.init(purchased: false, skProduct: skProduct, type: .consumable)
    }
}










