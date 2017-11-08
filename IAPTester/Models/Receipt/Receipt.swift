//
//  Receipt.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 11/3/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation

internal struct Receipt: Codable {
    
    let original_purchase_date_ms: String
    let is_trial_period: String?
    let product_id: String
    let quantity: String
    let expires_date_ms: String?
    
    var purchaseDate: Double? {
        return Double(self.original_purchase_date_ms)
    }
    
    var expirationDate: Double? {
        if let expirationDate = self.expires_date_ms {
            return Double(expirationDate)
        } else {
            return nil
        }
    }
}
