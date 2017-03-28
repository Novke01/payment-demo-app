//
//  TransactionViewController.swift
//  PaymentModuleDemoApp
//
//  Created by Marko Stajic on 3/28/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import UIKit

class TransactionViewController: UIViewController {

    @IBOutlet weak var transactionLabel: UILabel!
    var transaction : Transaction!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DataManager.sharedInstance.getTransactionByTrackingId(trackingId: self.transaction.trackingId) { (TransactionResponse) in
            if TransactionResponse.success {
                self.transactionLabel.text = TransactionResponse.transaction!.toString()
                print("Timestamp: \(TransactionResponse.transaction!.timestamp)")
                self.title = self.getDate(date: Date(timeIntervalSince1970: TransactionResponse.transaction!.timestamp/1000))
            }
        }
//        transactionLabel.text = transaction.toString()
        // Do any additional setup after loading the view.
    }
    
    func getDate(date: Date)->String {
        let df = DateFormatter()
        df.dateFormat = "dd MMM yyyy HH:mm"
        return df.string(from: date)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
