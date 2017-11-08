//
//  ProductManager.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 11/6/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation
import StoreKit

// This is the main interfacing class. Used to validate receipts, extract products from StoreKit, and carry out purchases
public class IAPManager {
    var skManager: StoreKitManager
    var receiptManager: ReceiptManager
    var products = [IAProduct]()
    weak var delegate: ProductManagerDelegate?
    let iapStoreInfo: [IAPStoreInfo]
    
    private var receiptsContainer: ReceiptsContainer?
    private var skProducts: [SKProduct]?
    
    private var productFactory: ProductFactory?
    

    init(appSecret: String, productsInfo: [IAPStoreInfo]) {
        self.iapStoreInfo = productsInfo
        let productIDs = Set(productsInfo.map{$0.productID})
        self.skManager = StoreKitManager(productIDs: productIDs)
        self.receiptManager = ReceiptManager(appSecret: appSecret)
    }
    
    func loadIAPs() {
        receiptManager.delegate = self
        skManager.delegate = self
        self.receiptManager.startValidatingReceipts()
        self.skManager.fetchAvailableProducts()
    }
    
    func purchase(product: IAProduct) {
        skManager.purchaseProduct(skProduct: product.skProduct)
    }
    
    private func attemptBuildProducts() {
        guard let receiptsContainer = self.receiptsContainer, let skProducts = self.skProducts else {return}
        let productFactory = ProductFactory()
        self.products = productFactory.producedProducts(from: receiptsContainer, skProducts: skProducts, iapInfo: self.iapStoreInfo)
        delegate?.allProductsProduced(products)
    }
}

extension IAPManager: ReceiptManagerDelegate {
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

extension IAPManager: StoreKitManagerDelegate {
    func failedAttempt(error: StoreKitManagerError) {
        switch error {
        case .failedPurchase(let failString):
            print(failString)
        case .failedRestore(let failString):
            print(failString)
        }
    }
    
    func received(products: [SKProduct]) {
        self.skProducts = products
        attemptBuildProducts()
    }
    
    func restoreCompleted() {
        
    }
    
    func productPurchased() {
        self.loadIAPs()
    }
    
}

protocol ProductManagerDelegate: class {
    func couldNotObtainReceipt(error: Error)
    func allProductsProduced(_ products: [IAProduct])
}
