//
//  ViewController.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 10/24/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ProductManagerDelegate {
    
    var appSecret: String = APP_SECRET
    var validationAttempted: Bool = false

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let productManager = ProductManager()
        productManager.start(appSecret: appSecret, productIDs: ["CP1", "NonCons", "AutoRenewSubsc"])
        productManager.delegate = self
       
    }
    
    func couldNotObtainReceipt(error: Error) {
       print("OH NO COULDN'T GET THE RECEIPT")
    }
    
    func allProductsProduced(_ products: [IAProduct]) {
        products.forEach{print($0.productID)}
    }
    
}

