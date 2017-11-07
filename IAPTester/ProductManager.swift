//
//  ProductManager.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 11/6/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation
import StoreKit

class ProductManager {
    
    var iapManager: IAPManager
    var receiptManager: ReceiptManager
    var products = [IAProduct]()
    weak var delegate: ProductManagerDelegate?
    
    var receiptsContainer: ReceiptsContainer?
    var skProducts: [SKProduct]?
    
    var productFactory: ProductFactory?
    
    init(appSecret: String, productIDs: Set<String>) {
        self.iapManager = IAPManager(productIDs: productIDs)
        self.receiptManager = ReceiptManager(appSecret: appSecret)
    }
    
    
    func start() {
        receiptManager.delegate = self
        iapManager.delegate = self
        
        self.receiptManager.startValidatingReceipts()
        self.iapManager.fetchAvailableProducts()
    }
    
    func receiveProducts(skProducts: [SKProduct], completion: () -> Void) -> Void {
        self.skProducts = skProducts
        completion()
    }
    
    private func attemptBuildProducts() {
        print("BUILD ATTEMPT")
        guard let receiptsContainer = self.receiptsContainer, let skProducts = self.skProducts else {return}
        print("VALID RECEIPT CONTAINER AND SK PRODUCTS")
        let productFactory = ProductFactory(receiptsContainer: receiptsContainer, skProducts: skProducts)
        self.products = productFactory.producedProducts()
        delegate?.allProductsProduced(products)
    }
}

extension ProductManager: ReceiptManagerDelegate {
    func response(_ response: ReceiptManagerResponse) {
        switch response {
        case .validReceipt(let receiptsContainer):
            self.receiptsContainer = receiptsContainer
            attemptBuildProducts()
        case .error(let error):
            delegate?.couldNotObtainReceipt(error: error)
        }
    }
}

extension ProductManager: IAPManagerDelegate {
    func received(products: [SKProduct]) {
        self.skProducts = products
        attemptBuildProducts()
    }
}

protocol ProductManagerDelegate: class {
    func couldNotObtainReceipt(error: Error)
    func allProductsProduced(_ products: [IAProduct])
}
