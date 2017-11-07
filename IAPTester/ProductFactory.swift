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
    
    let skProducts: [SKProduct]
    let receipts: [Receipt]
    let pendingRenewals: [PendingRenewal]
    
    var products = [IAProduct]()
    
    init(receiptsContainer: ReceiptsContainer, skProducts: [SKProduct]) {
        self.receipts = receiptsContainer.receipt.in_app
        self.skProducts = skProducts
        self.pendingRenewals = receiptsContainer.pending_renewal_info
    }
    
    func producedProducts() -> [IAProduct]{
        var iaProducts = [IAProduct]()
        for skProduct in skProducts {
            let filteredReceipts = receipts.filter{$0.product_id == skProduct.productIdentifier}
            if filteredReceipts.count > 0  {
                if filteredReceipts[0].is_trial_period == nil {
                    let nonConsumable = IANonConsumable(skProduct: skProduct, receipts: filteredReceipts)
                    iaProducts.append(nonConsumable)
                } else {
                    let index = pendingRenewals.index(where: { (renewal) -> Bool in
                        renewal.auto_renew_product_id == skProduct.productIdentifier
                    })
                    if let index = index {
                        let sortedReceipts = filteredReceipts.sorted(by: { (receipt1, receipt2) -> Bool in
                            if let date1 = receipt1.expires_date_ms, let date2 = receipt2.expires_date_ms {
                                return date1 >= date2
                            } else {
                                return false
                            }
                        })
                        if let paidSubsc = IASubscription(with: skProduct, receipt: sortedReceipts[0], pendingRenewal: pendingRenewals[index]) {
                            iaProducts.append(paidSubsc)
                        } else {
                            let notPurchased = IANotPurchased(skProduct: skProduct)
                            iaProducts.append(notPurchased)
                        }
                        
                    }
                }
            } else {
                let notPurchased = IANotPurchased(skProduct: skProduct)
                iaProducts.append(notPurchased)
            }
            
        }
        return iaProducts
    }
    
}
