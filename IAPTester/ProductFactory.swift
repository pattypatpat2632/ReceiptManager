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
    
    func producedProducts(from receiptsContainer: ReceiptsContainer, skProducts: [SKProduct], iapInfo: [IAPInfo]) -> [IAProduct]{
        let products = [IAProduct]()
        
        let receipts = receiptsContainer.receipt.in_app
        let pendingRenewals = receiptsContainer.pending_renewal_info
        
        for infoItem in iapInfo {
            if let skProduct = skProducts.first(where: {$0.productIdentifier == infoItem.productID}) {
                switch infoItem.type {
                case .autoSubscription:
                    let product = iapAutoSubscription(from: receipts, pendingRenewal: pendingRenewals, skProduct: skProduct)
                    products.append(product)
                case .subscription:
                    let product = iapSubscription(from: receipts, skProduct: skProduct)
                    products.append(product)
                case .nonConsumable:
                    let product = iapNonConsumable(from: receipts, skProduct: skProduct)
                    products.append(product)
                case .consumable:
                    let product = iapConsumable(from: receipts, skProduct: skProduct)
                    products.append(product)
                }
            }
        }
        return products
    }
    
    func iapAutoSubscription(from receipts: [Receipt], pendingRenewal: [PendingRenewal], skProduct: SKProduct) -> IAProduct {
        
    }
    
    func iapSubscription(from receipts: [Receipt], skProduct: SKProduct) -> IAProduct {
        
    }
    
    func iapNonConsumable(from receipts: [Receipt], skProduct: SKProduct) -> IAProduct {
        
    }
    
    func iapConsumable(from receipts: [Receipt], skProduct: SKProduct) -> IAProduct {
        
    }
    
}
