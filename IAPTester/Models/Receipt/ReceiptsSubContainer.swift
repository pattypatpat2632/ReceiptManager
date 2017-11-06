//
//  ReceiptsSubContainer.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 11/3/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation

public struct ReceiptsSubContainer: Codable {
    let bundle_id: String
    let in_app: [Receipt]
}
