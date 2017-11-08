//
//  IAProtocol.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 11/8/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation
import StoreKit

// Protocol for all in-app purchases
internal protocol IAProtocol {
    var purchased: Bool {get}
    var productID: String {get}
    var skProduct: SKProduct {get}
    var localizedDesciption: String {get}
    var localizedTitle: String {get}
    var price: Double {get}
    var priceLocale: Locale {get}
    var isDownloadable: Bool {get}
    var downloadContentLengths: [NSNumber] {get}
    var downloadContentVersion: String {get}
    
    var type: IAPType {get}
}

extension IAProtocol {
    var localizedDesciption: String {
        return skProduct.localizedDescription
    }
    var localizedTitle: String {
        return skProduct.localizedTitle
    }
    var price: Double {
        return skProduct.price.doubleValue
    }
    var priceLocale: Locale {
        return skProduct.priceLocale
    }
    var productID: String {
        return skProduct.productIdentifier
    }
    var isDownloadable: Bool {
        return skProduct.isDownloadable
    }
    var downloadContentLengths: [NSNumber] {
        return skProduct.downloadContentLengths
    }
    var downloadContentVersion: String {
        return skProduct.downloadContentVersion
    }
}

// Enum representing each type of in-app purchase
public enum IAPType {
    case subscription
    case autoSubscription
    case nonConsumable
    case consumable
}

// A class used to represent the information created by a user in the iTunes Connect
// Can either be entered manually, or loaded in from a database
// Will hopefully build extensions for communicating with database
public class IAPStoreInfo {
    let type: IAPType
    let productID: String
    
    init(type: IAPType, productID: String) {
        self.type = type
        self.productID = productID
    }
}
