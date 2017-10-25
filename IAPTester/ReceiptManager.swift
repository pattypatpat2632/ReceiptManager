//
//  ReceiptManager.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 10/25/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import Foundation
import StoreKit

#if DEBUG
    let IS_DEBUG = true
#else
    let IS_DEBUG = false
#endif

protocol ReceiptSomething {
    var appSecret: String {get}
}

final class ReceiptManager: NSObject, ReceiptSomething {
    
    var appSecret: String = APP_SECRET
    
    static let sharedInstance = ReceiptManager()
    
    var receiptValidationUrl: URL? {
        if IS_DEBUG {
            return URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")
        } else {
            return URL(string: "https://buy.itunes.apple.com/verifyReceipt")
        }
    }
    
    private override init() {
        super.init()
    }

    func startValidatingReceipts(completion: (()->Void)?) {
        if let isExist = try? getReceiptUrl()?.checkResourceIsReachable(), isExist == true {
            do {
                let data = try Data(contentsOf: getReceiptUrl()!)
                validate(data: data)
            } catch {
                
            }
        } else {
            let receiptRequest = SKReceiptRefreshRequest()
            receiptRequest.delegate = self
            receiptRequest.start()
        }
    }
    
    private func getReceiptUrl() -> URL? {
        return Bundle.main.appStoreReceiptURL
    }
    
    private func validate(data: Data) {
        guard let receiptValidUrl = receiptValidationUrl else {return} //TODO: error handling
        let encodedData = data.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
        var dic: [String: AnyObject] = ["receipt-data": encodedData as AnyObject]
        dic["password"] = appSecret as AnyObject
        
        let json = try! JSONSerialization.data(withJSONObject: dic, options: [])
        
        var urlRequest = URLRequest(url: receiptValidUrl)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = json
        let session = URLSession.shared
        _ = session.dataTask(with: urlRequest) { (data, response, error) in
            if let receiptData = data {
                self.parse(data: receiptData)
            } else {
                print("Error retrieving receipt data from itunes connect")
            }
        }.resume()
        
    }
    
    private func parse(data: Data) {
        let json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
        
        guard let status = json["status"] as? NSNumber else {return}
        if status == 0 {
            let receipt = json["receipt"] as! NSDictionary
            print("Receipt: \(receipt)")
            
            let purchases = receipt["in-app"] as! [NSDictionary]
            
            for purchase in purchases {
                let expiryDate = purchase["expiry_date_ms"]
                let productId = purchase["product_id"]
                let transactionId = purchase["transaction_id"]
                let isTrial = purchase["is_trial_period"]
                let purchaseDate = purchase["original_purchase_date"]
            }
            
        } else {
            print("error validating receipts")
        }
    }
    
    
}

extension ReceiptManager: SKRequestDelegate {
    func requestDidFinish(_ request: SKRequest) {
        startValidatingReceipts(completion: nil)
    }
}
