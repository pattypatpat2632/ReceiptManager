//
//  ReceiptsContainer.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 11/3/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.


import Foundation

internal struct ReceiptsContainer: Codable {
    let environment: String
    let status: Double
    let receipt: ReceiptsSubContainer?
    let pending_renewal_info: [PendingRenewal]?
}
