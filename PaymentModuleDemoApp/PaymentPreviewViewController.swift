//
//  PaymentPreviewViewController.swift
//  PaymentModuleDemoApp
//
//  Created by Aleksandar Novakovic on 3/20/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import UIKit

class PaymentPreviewViewController: UIViewController {
    
    @IBOutlet weak var billIdLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cardLabel: UILabel!
    
    var user: User!
    var card: Card!
    var price: String!
    var currency: String!
    var billId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        billIdLabel.text = billId
        currencyLabel.text = currency
        priceLabel.text = price
        cardLabel.text = "xxxx-xxxx-xxxx-" + card.last4Digits
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
