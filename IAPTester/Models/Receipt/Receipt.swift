//
//  Receipt.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 11/3/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation

public struct Receipt: Codable {
    let original_application_version: String
    let original_purchase_date_ms: String
    let receipt_creation_date_ms: String
    let receipt_type: String
    let request_date_ms: String
    let version_external_identifier: String
}
