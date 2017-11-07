//
//  IAPTesterTests.swift
//  IAPTesterTests
//
//  Created by Patrick O'Leary on 11/3/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import XCTest
import StoreKit

class IAPTesterTests: XCTestCase {
    var testData: Data?
    var receiptsContainer: ReceiptsContainer?
    
    override func setUp() {
        super.setUp()
        let path = Bundle.main.path(forResource: "test", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        testData = try! Data(contentsOf: url)
        self.receiptsContainer = try! JSONDecoder().decode(ReceiptsContainer.self, from: testData!)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    //MARK: Model tests
    
    func testReceiptsContainerModel() {
        if let data = testData {
            let receiptContainer = try! JSONDecoder().decode(ReceiptsContainer.self, from: data)
            XCTAssert(receiptContainer.environment == "Sandbox", "Did not get correct label from receipt container")
            XCTAssert(receiptContainer.pending_renewal_info.count >= 1, "There should be at least one pending renewal")
            XCTAssert(receiptContainer.receipt.bundle_id == "SweetPea.IAPTester", "Did not get receipt sub container")
            for receipt in receiptContainer.receipt.in_app {
                XCTAssert(receipt.original_purchase_date_ms != "0", "Check to make sure each receipt has a valid date")
            }
        } else {
            XCTFail("Invalid test data")
        }
    }
    
    func testValidatingReceipts() {
        
        class SpyDelegate: ReceiptManagerDelegate {
            var asyncExpectation: XCTestExpectation?
            
            func response(_ response: ReceiptManagerResponse) {
                switch response {
                case .validReceipt(let receiptsContainer):
                    XCTAssert(receiptsContainer.status == 0, "Did not get valid JSON data into receipts container")
                case .error(_):
                    XCTFail("Did not get valid receipt - make sure you are not testing on simulator")
                }
                asyncExpectation!.fulfill()
            }
        }
        
        let receiptManager = ReceiptManager(appSecret: APP_SECRET)
        let spyDelegate = SpyDelegate()
        receiptManager.delegate = spyDelegate
        
        let expectation = XCTestExpectation(description: "Expect receipt manager delegate to call response function")
        spyDelegate.asyncExpectation = expectation
        receiptManager.startValidatingReceipts()
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testIAPManager() {
        class SpyDeleate: IAPManagerDelegate {
            var asyncExpectation: XCTestExpectation?
            
            func received(products: [SKProduct]) {
                XCTAssert(products.count > 0, "No products returned to IAPManager Delegate")
                asyncExpectation?.fulfill()
            }
        }
        
        let iapManager = IAPManager(productIDs: ["CP1", "NonCons", "AutoRenewSubsc"])
        let spyDelegate = SpyDeleate()
        iapManager.delegate = spyDelegate
        
        let expectation = XCTestExpectation(description: "Expect IAPManager delegate to call received(products:)")
        spyDelegate.asyncExpectation = expectation
        iapManager.fetchAvailableProducts()
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testProductManager() {
        class SpyDelegate: ProductManagerDelegate {
            
            var productExpectation: XCTestExpectation?
            
            func allProductsProduced(_ products: [IAProduct]) {
                XCTAssert(products.count > 0, "Product manager did not create valid instances of IAProduct")
                productExpectation!.fulfill()
            }
            
            func couldNotObtainReceipt(error: Error) {
                XCTFail("Could not obtain IAP receipt - make sure you are testing on a phone and not on simulator")
            }
        }
        let productManager = ProductManager(appSecret: APP_SECRET, productIDs: ["CP1", "NonCons", "AutoRenewSubsc"])
        let spyDelegate = SpyDelegate()
        productManager.delegate = spyDelegate

        
        let expectation = XCTestExpectation(description: "Expect async return from ProductManager delegate")

        spyDelegate.productExpectation = expectation
        productManager.start()
        wait(for: [expectation], timeout: 10)
        
    }

    
}
