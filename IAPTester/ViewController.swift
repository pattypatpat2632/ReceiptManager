//
//  ViewController.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 10/24/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ProductManagerDelegate {
    
    @IBOutlet var label: UILabel!
    
    var appSecret: String = APP_SECRET
    
    var productManager = ProductManager(appSecret: APP_SECRET, productsInfo: [])
    

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let product1 = IAPStoreInfo(type: .consumable, productID: "CP1")
        let product2 = IAPStoreInfo(type: .nonConsumable, productID: "NonCons")
        let product3 = IAPStoreInfo(type: .autoSubscription, productID: "AutoRenewSubsc")
        productManager = ProductManager(appSecret: APP_SECRET, productsInfo: [product1, product2, product3])
        productManager.start()
        productManager.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    func couldNotObtainReceipt(error: Error) {
        print("Oh no error!")
    }
    
    func allProductsProduced(_ products: [IAProtocol]) {
        print("\n***** RESULTS *****\n")
        products.forEach{print("\($0.productID) \($0.type) \($0.purchased)")}
        print("\n")
    }
    
}

