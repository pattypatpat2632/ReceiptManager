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
        
        
        let path = Bundle.main.path(forResource: "test", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        testData = try! Data(contentsOf: url)
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
