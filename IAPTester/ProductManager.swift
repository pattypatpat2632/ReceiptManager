//
//  ProductManager.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 11/6/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation
import StoreKit

//class for managing all IAProducts
public class ProductManager {
    
    private var iapManager: IAPManager?
    private var receiptManager: ReceiptManager?
    var products = [IAProduct]()
    weak var delegate: ProductManagerDelegate?
    
    private var receiptsContainer: ReceiptsContainer?
    private var skProducts: [SKProduct]?
    
    private var productFactory: ProductFactory?
    
    func start(appSecret: String, productIDs: Set<String>) {
        self.iapManager = IAPManager(productIDs: productIDs)
        self.receiptManager = ReceiptManager(appSecret: appSecret)
        receiptManager?.delegate = self
        iapManager?.delegate = self
        self.receiptManager?.startValidatingReceipts()
        self.iapManager?.fetchAvailableProducts()
    }
    
    private func attemptBuildProducts() {
        guard let receiptsContainer = self.receiptsContainer, let skProducts = self.skProducts else {return}
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
