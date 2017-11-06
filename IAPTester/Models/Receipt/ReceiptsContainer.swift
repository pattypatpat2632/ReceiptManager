//
//  ReceiptsContainer.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 11/3/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation

public struct ReceiptsContainer: Codable {
    let environment: String
    let status: String
    let receipt: ReceiptsSubContainer
}
