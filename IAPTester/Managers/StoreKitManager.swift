//
//  IAPPurchaseHandler.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 10/24/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation
import StoreKit

// This class handles all of the calls to StoreKit

internal class StoreKitManager: NSObject {
    
    private let productIDs: Set<String>
    
    weak var delegate: StoreKitManagerDelegate?
    
    private var productsRequest = SKProductsRequest()
    private var skProducts = [SKProduct]()
    
    var allProducts: [SKProduct] {
        return skProducts
    }
    
    init(productIDs: Set<String>) {
        self.productIDs = productIDs
        super.init()
    }
    
    //MARK: interfaced functions
    
    // Fetches all of the available SKProducts created in iTunes Connect
    func fetchAvailableProducts(){
        productsRequest = SKProductsRequest(productIdentifiers: productIDs)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    // Adds a product purchase to the payment queue
    func purchaseProduct(skProduct: SKProduct) {
        guard canMakePurchases() else {
            delegate?.failedAttempt(error: .failedPurchase("User unable to make purchases"))
            return
        }
        guard skProducts.count > 0 else {return}
        
        guard let index = skProducts.index(of: skProduct) else {
            delegate?.failedAttempt(error: .failedPurchase("Product does not exist in iTunes Connect"))
            return
        }
        let product = skProducts[index]
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }
    
    // Adds a product resore to the payment queue
    func restoreProducts() {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    private func canMakePurchases() -> Bool { return SKPaymentQueue.canMakePayments() }
}


// MARK: SKProductsRequestDelegate
extension StoreKitManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        skProducts = response.products
        delegate?.received(products: response.products)
    }
}


// MARK: SKPAymentTransactionObserver
extension StoreKitManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                delegate?.productPurchased()
            case .failed:
                 SKPaymentQueue.default().finishTransaction(transaction)
            case .purchasing:
                print("purchasing product")
            case .restored:
                 SKPaymentQueue.default().finishTransaction(transaction)
            case .deferred:
                print("Deferred payment")
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        delegate?.restoreCompleted()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        delegate?.failedAttempt(error: .failedRestore(error.localizedDescription))
    }
}


// MARK: StoreKitManagerDelegate
protocol StoreKitManagerDelegate: class {
    func received(products: [SKProduct])
    func productPurchased()
    func restoreCompleted()
    func failedAttempt(error: StoreKitManagerError)
}


// MARK: StoreKitManagerError
enum StoreKitManagerError: Error {
    case failedPurchase(String)
    case failedRestore(String)
}
