//
//  MainViewController.swift
//  PaymentModuleDemoApp
//
//  Created by Aleksandar Novakovic on 3/17/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let newPaymentSegueId = "goToNewPayment"
    let addNewCardSegueId = "goToAddNewCard"
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var user: User!
    var checkoutId = ""
    
//    paymentType	PA
//    customer.merchantCustomerId	marko.stajic@gmail.com
//    customParameters[SHOPPER_action]	createCard
//    customer.email	marko.stajic@gmail.com
//    billing.postcode	0
//    amount	1.00
//    billing.country	RS
//    createRegistration	true
//    currency	RSD
//    customer.phone	+38166066068
//    customer.givenName	Marko Stajic
//    customParameters[SHOPPER_customerId]	marko.stajic@gmail.com
//    authentication.entityId	8a82941758447b880158498cb4cf35f2
//    authentication.password	h43rCBBsFR
//    authentication.userId	8a82941758447b880158498cb4cf35f6

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let user = User(email: "marko.stajic@gmail.com", imei: "355330084909367", name: "Marko Stajic", phone: "+38166066068")
        
        //register:
//        DataManager.sharedInstance.register(user: user) { (GeneralResponse) in
//            if GeneralResponse.success {
//                print("\(GeneralResponse.message)")
//            }else{
//                print("Error: \(GeneralResponse.message)")
//            }
//        }
        
        //login and get cards
//        DataManager.sharedInstance.login(user: user, pin: "6341", pushToken: appDelegate.deviceToken) { (LoginResponse) in
//            if LoginResponse.success {
//                print("\(LoginResponse.user!.toString())")
//                self.user = LoginResponse.user!
//                
//                DataManager.sharedInstance.getCards(email: self.user.email, completion: { (CardsResponse) in
//                    if CardsResponse.success {
//                        for card in CardsResponse.cards! {
//                            print("\(card.toString())")
//                        }
//                    }
//                })
//                
//                DataManager.sharedInstance.getChannels(completion: { (ChannelsResponse) in
//                    if ChannelsResponse.success {
//                        for channel in ChannelsResponse.channels! {
//                            print("\(channel.toString())")
//                        }
//                    }
//                })
//                
////                DataManager.sharedInstance.getCards(email: self.user.email, completion: { (GeneralResponse) in
////                    print("\(GeneralResponse.message)")
////                })
//                
//            }else{
//                print("Error: \(LoginResponse.message)")
//            }
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == newPaymentSegueId {
            let newPaymentController = segue.destination as! NewPaymentViewController
            newPaymentController.user = self.user
        }
        else if segue.identifier == addNewCardSegueId {
            if let destVC = segue.destination as? NewCardViewController {
                destVC.checkoutId = self.checkoutId
            }
        }
    }
    
    @IBAction func addNewCard(_ sender: UIButton) {
        
        DataManager.sharedInstance.addCard(completion: { (checkoutId) in
            if let id = checkoutId {
                print("Checkout id: \(id)")

                DispatchQueue.main.sync {
                    
                    self.checkoutId = id
                    self.performSegue(withIdentifier: self.addNewCardSegueId, sender: self)
                    
                }
            }
        })
    }
    
    @IBAction func makePayment(_ sender: Any) {
        performSegue(withIdentifier: newPaymentSegueId, sender: user)
    }
    
}

