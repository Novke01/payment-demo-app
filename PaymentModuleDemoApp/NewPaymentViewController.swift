//
//  NewPaymentViewController.swift
//  PaymentModuleDemoApp
//
//  Created by Aleksandar Novakovic on 3/20/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import UIKit

class NewPaymentViewController: UIViewController {
    
    let cardSelectionSegueId = "goToCardSelection"
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func proceed(_ sender: Any) {
        performSegue(withIdentifier: cardSelectionSegueId, sender: nil)
    }

}
