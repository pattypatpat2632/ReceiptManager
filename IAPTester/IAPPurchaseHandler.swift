//
//  IAPPurchaseHandler.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 10/24/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation
import StoreKit

class IAPPurchaseHandler: NSObject {
    
    let consumableID = "CP1"
    
    fileprivate var currentProduct = SKProduct()
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var iapProducts = [SKProduct]()
    
    func canMakePurchases() -> Bool { return SKPaymentQueue.canMakePayments() }
    
    func fetchAvailableProducts(){
        if canMakePurchases() {print("Purchases allowed")}
        print("FETCHING PRODUCTS")
        let productIdentifiers: Set = [consumableID]
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func purchaseProduct() {
        guard canMakePurchases() else {return}
        guard iapProducts.count > 0 else {
            print("NO PRODUCTS TO PURCHASE")
            return}
        
        let product = iapProducts[0]
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
        currentProduct = product
    }
}

extension IAPPurchaseHandler: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("RESPONSE RECEIVED")
        iapProducts = response.products
        response.products.forEach{
            print($0.productIdentifier)
        }
    }
}

extension IAPPurchaseHandler: SKPaymentTransactionObserver {
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
            default:
                print("default product transaction")
            }
        }
    }
    
    func handlePurchasedState(for transaction: SKPaymentTransaction, inQueue queue: SKPaymentQueue) {
        queue.finishTransaction(transaction)
    }
}
