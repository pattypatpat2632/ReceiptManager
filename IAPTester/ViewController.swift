//
//  ViewController.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 10/24/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ReceiptManager {
    
    var appSecret: String = APP_SECRET
    
    @IBOutlet var label: UILabel!
    let purchaseHandler = IAPManager(productIDs: [])
    var appSecret: String = APP_SECRET
    var validationAttempted: Bool = false

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        purchaseHandler.fetchAvailableProducts()

    }
    
}

