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
    let productManager = ProductManager(appSecret: APP_SECRET, productIDs: ["CP1", "NonCons", "AutoRenewSubsc"])
    

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        productManager.start()
        productManager.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    func couldNotObtainReceipt(error: Error) {
        print("Oh no error!")
    }
    
    func allProductsProduced(_ products: [IAProduct]) {
        print("\n***** RESULTS *****\n")
        products.forEach{print($0.productID)}
        print("\n")
    }
    
}

