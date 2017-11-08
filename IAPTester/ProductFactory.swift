//
//  ProductFactory.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 11/7/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation
import StoreKit

internal class ProductFactory {
    
    func producedProducts(from receiptsContainer: ReceiptsContainer, skProducts: [SKProduct], iapInfo: [IAPStoreInfo]) -> [IAProtocol]{
        var products = [IAProtocol]()
        
        let sortedReceipts = receiptsSortedByExpiration(fromContainer: receiptsContainer)
        let pendingRenewals = receiptsContainer.pending_renewal_info
        
        for infoItem in iapInfo {
            if let skProduct = skProducts.first(where: {$0.productIdentifier == infoItem.productID}) {
                switch infoItem.type {
                case .autoSubscription:
                    let product = iapAutoSubscription(from: sortedReceipts, pendingRenewals: pendingRenewals, skProduct: skProduct)
                    products.append(product)
                case .subscription:
                    let product = iapSubscription(from: sortedReceipts, skProduct: skProduct)
                    products.append(product)
                case .nonConsumable:
                    let product = iapNonConsumable(from: sortedReceipts, skProduct: skProduct)
                    products.append(product)
                case .consumable:
                    let product = iapConsumable(from: sortedReceipts, skProduct: skProduct)
                    products.append(product)
                }
            }
        }
        return products
    }
    
    private func iapAutoSubscription(from receipts: [Receipt]?, pendingRenewals: [PendingRenewal]?, skProduct: SKProduct) -> IAProtocol {
        var receipt: Receipt? = nil
        var pendingRenewal: PendingRenewal?
        
        if let receipts = receipts {
            if let index = receipts.index(where: {$0.product_id == skProduct.productIdentifier}) {
                receipt = receipts[index]
            }
        }
        
        if let pendingRenewals = pendingRenewals, let index = pendingRenewals.index(where: {$0.auto_renew_product_id == skProduct.productIdentifier}) {
            pendingRenewal = pendingRenewals[index]
        }
        
        return IAPAutoSubscription(with: skProduct, receipt: receipt, pendingRenewal: pendingRenewal)
    }
    
    private func iapSubscription(from receipts: [Receipt]?, skProduct: SKProduct) -> IAProtocol {
        var receipt: Receipt? = nil
        if let receipts = receipts {
            if let index = receipts.index(where: {$0.product_id == skProduct.productIdentifier}) {
                receipt = receipts[index]
            }
        }
        
        return IAPSubscription(with: skProduct, receipt: receipt)
    }
    
    private func iapNonConsumable(from receipts: [Receipt]?, skProduct: SKProduct) -> IAProtocol {
        guard let receipts = receipts else {return IAPNonConsumable(skProduct: skProduct, receipts: nil)}
        let matchingReceipts = receipts.filter{$0.product_id == skProduct.productIdentifier}
        if matchingReceipts.count > 0 {
            return IAPNonConsumable(skProduct: skProduct, receipts: matchingReceipts)
        } else {
            return IAPNonConsumable(skProduct: skProduct, receipts: nil)
        }
    }
    
    private func iapConsumable(from receipts: [Receipt]?, skProduct: SKProduct) -> IAProtocol {
        return IAPConsumable(skProduct: skProduct)
    }
    
    private func receiptsSortedByExpiration(fromContainer container: ReceiptsContainer) -> [Receipt]? {
        guard let receipts = container.receipt?.in_app else {return nil}
        return receipts.sorted{ (receipt1, receipt2) in
            if let date1 = receipt1.expires_date_ms, let date2 = receipt2.expires_date_ms {
                return date1 >= date2
            } else {
                return receipt1.expires_date_ms != nil
            }
        }
    }
    
}
