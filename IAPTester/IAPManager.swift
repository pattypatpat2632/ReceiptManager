//
//  IAPPurchaseHandler.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 10/24/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation
import StoreKit

class IAPManager: NSObject {
    
    let consumableID = "CP1"
    let productIDs: Set<String>
    
    fileprivate var currentProduct = SKProduct()
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var iapProducts = [SKProduct]()
    
    var allProducts: [SKProduct] {
        return iapProducts
    }
    
    init(productIDs: Set<String>) {
        self.productIDs = productIDs
        super.init()
    }
    
    func canMakePurchases() -> Bool { return SKPaymentQueue.canMakePayments() }
    
    func fetchAvailableProducts(){
        if canMakePurchases() {print("Purchases allowed")}
        let productIdentifiers: Set<String> = productIDs
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func purchaseProduct() {
        guard canMakePurchases() else {return}
        guard iapProducts.count > 0 else {
            return}
        
        let product = iapProducts[0]
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
        currentProduct = product
    }
    
    func restoreProducts() {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension IAPManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        iapProducts = response.products
    }
}

extension IAPManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            
            switch transaction.transactionState {
            case .purchased:
                print("Product purchased:\(currentProduct.productIdentifier)")
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                print("purchase failed: \(currentProduct.productIdentifier)")
                 SKPaymentQueue.default().finishTransaction(transaction)
            case .purchasing:
                print("purchasing product")
            case .restored:
                print("restored product")
                print("Product restored:\(currentProduct.productIdentifier)")
                 SKPaymentQueue.default().finishTransaction(transaction)
            case .deferred:
                print("Deferred payment")

            }
        }
    }
    
    func handlePurchasedState(for transaction: SKPaymentTransaction, inQueue queue: SKPaymentQueue) {
        queue.finishTransaction(transaction)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        
        return true
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        
    }
}
