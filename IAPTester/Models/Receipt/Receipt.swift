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
}
