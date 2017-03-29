//
//  CardSelectionViewController.swift
//  PaymentModuleDemoApp
//
//  Created by Aleksandar Novakovic on 3/20/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import UIKit

class CardSelectionViewController: BaseViewController {

    @IBOutlet weak var cardsList: UITableView!
    
    let paymentPreviewSegueId = "goToPaymentPreview"
    let payWithNewCardSegueId = "goToPayWithNewCard"
    let reusableCellIdentifier = "cell"
    
    var user: User!
    var price: String!
    var currency: String!
    var billId: String!
    
    var selectedCard: Card?
    
    var cards = [Card]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        cardsList.register(UITableViewCell.self, forCellReuseIdentifier: reusableCellIdentifier)
        cardsList.delegate = self;
        cardsList.dataSource = self;
        
        DataManager.sharedInstance.getCards(email: user.email, completion: { (cardsResponse) in
            if cardsResponse.success {
                self.cards = cardsResponse.cards!
                self.cardsList.reloadData()
            }
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cardsList.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == paymentPreviewSegueId {
            let paymentPreviewController = segue.destination as! PaymentPreviewViewController
            paymentPreviewController.user = self.user
            paymentPreviewController.card = self.selectedCard
            paymentPreviewController.price = self.price
            paymentPreviewController.currency = self.currency
            paymentPreviewController.billId = self.billId
        }
    }
    
    @IBAction func addNewCard(_ sender: Any) {
        performSegue(withIdentifier: payWithNewCardSegueId, sender: nil)
    }

}

extension CardSelectionViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell: UITableViewCell = cardsList.dequeueReusableCell(withIdentifier: reusableCellIdentifier, for: indexPath) as UITableViewCell!
        let exp = "  Exp: " + cards[indexPath.row].monthExp + "/" + cards[indexPath.row].yearExp
        newCell.textLabel?.text = (cards[indexPath.row].brand ?? "") + "  " + "xxxx-xxxx-xxxx-" + cards[indexPath.row].last4Digits + exp
        return newCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCard = cards[indexPath.row]
        performSegue(withIdentifier: paymentPreviewSegueId, sender: self)
    }
    
}
