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

protocol ReceiptManager: SKRequestDelegate {
    
    var appSecret: String {get}
    
    func startValidatingReceipts(completion: (()->Void)?)
}

extension ReceiptManager {
    private var receiptValidationUrl: URL? {
        if IS_DEBUG {
            return URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")
        } else {
            return URL(string: "https://buy.itunes.apple.com/verifyReceipt")
        }
    }
    
    private var localReceiptUrl: URL? {
        return Bundle.main.appStoreReceiptURL
    }
    
    func startValidatingReceipts(completion: (()->Void)?) {
        print("START VALIDATING CALLED")
        if let isExist = try? localReceiptUrl?.checkResourceIsReachable(), isExist == true {
            do {
                print("VALID DATA AT URL")
                let data = try Data(contentsOf: localReceiptUrl!)
                validate(data: data)
            } catch {
                
            }
        } else {
            let receiptRequest = SKReceiptRefreshRequest()
            receiptRequest.delegate = self
            receiptRequest.start()
        }
    }
    
    private func parse(data: Data) {
        let json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
        print(json)

        
        guard let status = json["status"] as? NSNumber else {return}
        if status == 0 {
            let receipt = json["receipt"] as! NSDictionary
            print("Receipt: \(receipt)")
            
            let purchases = receipt["in_app"] as! [NSDictionary]
            
            for _ in purchases {
                print("PURCHASE FOUND")
            }
            
        } else {
            print("error validating receipts")
        } 
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
    
    func requestDidFinish(_ request: SKRequest) {
        startValidatingReceipts(completion: nil)
    }
}
