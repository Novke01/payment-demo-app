//
//  NewPaymentViewController.swift
//  PaymentModuleDemoApp
//
//  Created by Aleksandar Novakovic on 3/20/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import UIKit

class NewPaymentViewController: BaseViewController {
    
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var currencyTextField: UITextField!
    
    let cardSelectionSegueId = "goToCardSelection"
    var user: User!
    var price: String?
    var currency: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == cardSelectionSegueId {
            let cardSelectionController = segue.destination as! CardSelectionViewController
            let newPaymentViewController = sender as! NewPaymentViewController
            cardSelectionController.user = newPaymentViewController.user
            cardSelectionController.price = newPaymentViewController.price
            cardSelectionController.currency = newPaymentViewController.currency
        }
    }

    @IBAction func proceed(_ sender: Any) {
        if let price = priceTextField?.text, let currency = currencyTextField?.text {
            if price != "" && currency != "" {
                self.price = price
                self.currency = currency
                performSegue(withIdentifier: cardSelectionSegueId, sender: self)
            }
        }
    }

}
