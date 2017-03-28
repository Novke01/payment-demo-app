//
//  CardsViewController.swift
//  PaymentModuleDemoApp
//
//  Created by Aleksandar Novakovic on 3/28/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController {

    @IBOutlet weak var cardsTable: UITableView!
    
    let newCardSegueId = "goToNewCard"
    
    let reusableCellId = "cell"
    
    var user: User!
    var channel: Channel!
    var cards = [Card]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardsTable.register(UITableViewCell.self, forCellReuseIdentifier: reusableCellId)
        cardsTable.delegate = self
        cardsTable.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DataManager.sharedInstance.getCards(email: user.email, completion: { (cardsResponse) -> Void in
            if cardsResponse.success {
                self.cards = cardsResponse.cards!
                self.cardsTable.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == newCardSegueId {
            let newCardVC: NewCardViewController = segue.destination as! NewCardViewController
            newCardVC.checkoutId = sender as! String
        }
    }
    
    @IBAction func addNewCard(_ sender: Any) {
        
        DataManager.sharedInstance.addCard(channel: channel, completion: { (checkoutId) in
            if let id = checkoutId {
                print("Checkout id: \(id)")
                DispatchQueue.main.sync {
                    self.performSegue(withIdentifier: self.newCardSegueId, sender: checkoutId)
                }
            }
        })
        
    }
    
    @IBAction func unwindToCardsView(segue: UIStoryboardSegue) {}

}

extension CardsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = cardsTable.dequeueReusableCell(withIdentifier: reusableCellId, for: indexPath)
        newCell.textLabel?.text = "xxxx-xxxx-xxxx-" + cards[indexPath.row].last4Digits
        return newCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let index = indexPath.row
        if editingStyle == .delete {
            DataManager.sharedInstance.removeCard(cardId: cards[index].token, completion: { (generalResponse) -> Void in
                self.cards.remove(at: index)
                self.cardsTable.reloadData()
            })
        }
    }

}
