//
//  PendingRenewal.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 11/6/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation

struct PendingRenewal: Codable {
    let expiration_intent: String
    let auto_renew_product_id: String
    let original_transaction_id: String
    let auto_renew_status: String
}
