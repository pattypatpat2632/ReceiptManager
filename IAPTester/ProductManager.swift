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
    var iapManager: IAPManager
    var receiptManager: ReceiptManager
    var products = [IAProtocol]()
    weak var delegate: ProductManagerDelegate?
    let iapStoreInfo: [IAPStoreInfo]
    
    private var receiptsContainer: ReceiptsContainer?
    private var skProducts: [SKProduct]?
    
    private var productFactory: ProductFactory?
    

    init(appSecret: String, productsInfo: [IAPStoreInfo]) {
        self.iapStoreInfo = productsInfo
        let productIDs = Set(productsInfo.map{$0.productID})
        self.iapManager = IAPManager(productIDs: productIDs)
        self.receiptManager = ReceiptManager(appSecret: appSecret)
    }
    
    func start() {
        receiptManager.delegate = self
        iapManager.delegate = self
        self.receiptManager.startValidatingReceipts()
        self.iapManager.fetchAvailableProducts()
    }
    
    private func attemptBuildProducts() {
        guard let receiptsContainer = self.receiptsContainer, let skProducts = self.skProducts else {return}
        let productFactory = ProductFactory()
        self.products = productFactory.producedProducts(from: receiptsContainer, skProducts: skProducts, iapInfo: self.iapStoreInfo)
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
    func allProductsProduced(_ products: [IAProtocol])
}
