//
//  ProductManager.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 11/6/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation

class ProductManager {
    var appSecret: String
    var iapManager: IAPManager
    
    init(appSecret: String, productIDs: Set<String>) {
        self.appSecret = appSecret
        self.iapManager = IAPManager(productIDs: productIDs)
    }
}
