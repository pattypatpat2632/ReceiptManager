//
//  ReceiptManager.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 10/25/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

// This is a protocol for handling all of the calls to Apple's receipt validation

import Foundation
import StoreKit

#if DEBUG
let IS_DEBUG = true
#else
let IS_DEBUG = false
#endif

internal class ReceiptManager: NSObject, SKRequestDelegate {
    
    var appSecret: String
    var validationAttempted: Bool = false
    var receiptsContainer: ReceiptsContainer?
    
    weak var delegate: ReceiptManagerDelegate?
    
    init(appSecret: String) {
        self.appSecret = appSecret
        super.init()
    }
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
    

    func startValidatingReceipts() {

        if let isExist = try? localReceiptUrl?.checkResourceIsReachable(), isExist == true {
            do {
                print("VALID DATA AT URL")
                let data = try Data(contentsOf: localReceiptUrl!)
                validate(data: data) { response in
                    self.delegate?.response(response)
                }
            } catch {
                let parseError = ReceiptManagerError.parseError(description: "Invalid data found in contents of local receipt")
                
                self.delegate?.response(.error(parseError))
                
            }
        } else {

            if !validationAttempted {
                let receiptRequest = SKReceiptRefreshRequest()
                receiptRequest.delegate = self
                receiptRequest.start()
                validationAttempted = true
            } else {
                let error = ReceiptManagerError.noReceipt(description: "No receipt could be retrieved")
                self.delegate?.response(.error(error))
                
            }
        }
    }
    
    
    
    private func validate(data: Data, completion: @escaping (ReceiptManagerResponse) -> Void) {

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
                do {
                    let receiptsContainer = try JSONDecoder().decode(ReceiptsContainer.self, from: receiptData)
                    completion(.validReceipt(receiptsContainer))
                } catch {
                    let parseError = ReceiptManagerError.parseError(description: "Could not decode JSON data into receipts container")
                    completion(.error(parseError))
                }
            } else {
                let parseError = ReceiptManagerError.parseError(description: "Error retrieving receipt data from itunes connect")
                completion(.error(parseError))
            }
            }.resume()
    }
    
    @objc func requestDidFinish(_ request: SKRequest) {
        startValidatingReceipts()
    }
}

enum ReceiptManagerResponse {
    case validReceipt(ReceiptsContainer)
    case error(ReceiptManagerError)
}

enum ReceiptManagerError: Error {
    case parseError(description: String)
    case noReceipt(description: String)
}

protocol ReceiptManagerDelegate: class {
    func response(_ response: ReceiptManagerResponse)
}
