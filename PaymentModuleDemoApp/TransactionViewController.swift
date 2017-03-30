//
//  TransactionViewController.swift
//  PaymentModuleDemoApp
//
//  Created by Marko Stajic on 3/28/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import UIKit

class TransactionViewController: BaseViewController {

    @IBOutlet weak var transactionLabel: UILabel!
    var transactionTrackId : String!
    var counter = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkTransaction()

//        transactionLabel.text = transaction.toString()
        // Do any additional setup after loading the view.
    }
    
    func checkTransaction(){
        self.startLoading()
        DataManager.sharedInstance.getTransactionByTrackingId(trackingId: self.transactionTrackId) { (TransactionResponse) in
            self.stopLoading()
            if TransactionResponse.success {
                self.transactionLabel.text = TransactionResponse.transaction!.toString()
                print("Timestamp: \(TransactionResponse.transaction!.timestamp)")
                self.title = self.getDate(date: Date(timeIntervalSince1970: TransactionResponse.transaction!.timestamp/1000))
            }else{
                if self.counter > 0 {
                    self.counter -= 1
                    self.checkTransaction()
                }
            }
        }
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
