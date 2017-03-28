//
//  TransactionsViewController.swift
//  PaymentModuleDemoApp
//
//  Created by Marko Stajic on 3/28/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import UIKit

class TransactionsViewController: BaseViewController {

    var transactions = [Transaction]()
    @IBOutlet weak var tableView: UITableView!
    let reusableCellId = "cell"
    let viewTransactionId = "goToTransaction"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reusableCellId)
        
        DataManager.sharedInstance.getTransactions(email: (UIApplication.shared.delegate as! AppDelegate).user.email, page: 0, transactionCount: 20) { (TransactionsResponse) in
            if TransactionsResponse.success {
                for i in TransactionsResponse.transacations! {
                    self.transactions.append(i)
                }
                self.tableView.reloadData()
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == viewTransactionId {
            let transVC = segue.destination as! TransactionViewController
            transVC.transaction = sender as! Transaction
        }
    }

}

extension TransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = tableView.dequeueReusableCell(withIdentifier: reusableCellId, for: indexPath)
        newCell.textLabel?.text = "ID: \(transactions[indexPath.row].trackingId) - Amount: \(transactions[indexPath.row].amount) - Card:\(transactions[indexPath.row].last4digits) "
        return newCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: viewTransactionId, sender: transactions[indexPath.row])
    }
}

