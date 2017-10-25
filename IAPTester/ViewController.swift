//
//  ViewController.swift
//  IAPTester
//
//  Created by Patrick O'Leary on 10/24/17.
//  Copyright © 2017 Patrick O'Leary. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var label: UILabel!
    let purchaseHandler = IAPPurchaseHandler()

    override func viewDidLoad() {
        super.viewDidLoad()
        purchaseHandler.fetchAvailableProducts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func purchaseTapped(_ sender: Any) {
        purchaseHandler.purchaseProduct()
    }
    @IBAction func purchaseNonConsTapped(_ sender: Any) {
    }
    @IBAction func purchaseSubTapped(_ sender: Any) {
    }
    
}

