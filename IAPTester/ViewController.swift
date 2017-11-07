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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }

    @IBAction func purchaseTapped(_ sender: Any) {
        purchaseHandler.purchaseProduct()
    }
    @IBAction func purchaseNonConsTapped(_ sender: Any) {
    }
    @IBAction func purchaseSubTapped(_ sender: Any) {
    }
    
}

