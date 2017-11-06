//
//  IAPTesterTests.swift
//  IAPTesterTests
//
//  Created by Patrick O'Leary on 11/3/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import XCTest

class IAPTesterTests: XCTestCase {
    var testData: Data?
    
    override func setUp() {
        super.setUp()
        let testJSON: [String: Any] = [
            "environment" : "Sandbox",
            "receipt" : [
                "adam_id" : "0",
                "app_item_id" : "0",
                "application_version" : "2",
                "bundle_id" : "SweetPea.IAPTester",
                "download_id" : "0",
                "in_app" : [
                    [
                        "original_application_version" : "1.0",
                        "original_purchase_date" : "2013-08-01 07:00:00 Etc/GMT",
                        "original_purchase_date_ms" : "1375340400000",
                        "original_purchase_date_pst" : "2013-08-01 00:00:00 America/Los_Angeles",
                        "receipt_creation_date" : "2017-11-03 18:00:52 Etc/GMT",
                        "receipt_creation_date_ms" : "1509732052000",
                        "receipt_creation_date_pst" : "2017-11-03 11:00:52 America/Los_Angeles",
                        "receipt_type" : "ProductionSandbox",
                        "request_date" : "2017-11-03 18:04:38 Etc/GMT",
                        "request_date_ms" : "1509732278403",
                        "request_date_pst" : "2017-11-03 11:04:38 America/Los_Angeles",
                        "version_external_identifier" : "0"
                    ],
                    [
                        "expires_date" : "2017-11-06 16:18:08 Etc/GMT",
                        "expires_date_ms" : "1509985088000",
                        "expires_date_pst" : "2017-11-06 08:18:08 America/Los_Angeles",
                        "is_trial_period" : true,
                        "original_purchase_date" : "2017-11-06 16:15:09 Etc/GMT",
                        "original_purchase_date_ms" : "1509984909000",
                        "original_purchase_date_pst" : "2017-11-06 08:15:09 America/Los_Angeles",
                        "original_transaction_id" : "1000000350033379",
                        "product_id" : "AutoRenewSubsc",
                        "purchase_date" : "2017-11-06 16:15:08 Etc/GMT",
                        "purchase_date_ms" : "1509984908000",
                        "purchase_date_pst" : "2017-11-06 08:15:08 America/Los_Angeles",
                        "quantity" : "1",
                        "transaction_id" : "1000000350033379",
                        "web_order_line_item_id" : "1000000036803204",
                    ]
                ]
            ],
            "status" : "0"
        ]
        
        testData = try? JSONSerialization.data(withJSONObject: testJSON, options: [])
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReceiptsContainerModel() {
        if let data = testData {
            let receiptContainer = try! JSONDecoder().decode(ReceiptsContainer.self, from: data)
            XCTAssert(receiptContainer.environment == "Sandbox", "Did not get correct label from receipt container")
            XCTAssert(receiptContainer.receipt.bundle_id == "SweetPea.IAPTester", "Did not get receipt sub container")
            for receipt in receiptContainer.receipt.in_app {
                XCTAssert(receipt.receipt_type == "ProductionSandbox", "Did not get valid in app receipt data from receipt container")
            }
        } else {
            XCTAssert(false, "testData was nil")
        }
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
