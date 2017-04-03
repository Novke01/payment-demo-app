//
//  MainViewController.swift
//  PaymentModuleDemoApp
//
//  Created by Aleksandar Novakovic on 3/17/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class MainViewController: BaseViewController {
    
    let newPaymentSegueId = "goToNewPayment"
    let viewCardsSegueId = "goToCards"
    let scanQRCodeSegueId = "goToScanQRCode"
    let viewTransactionsId = "goToTransactions"
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var user: User = (UIApplication.shared.delegate as! AppDelegate).user
    var checkoutId = ""
    var channels = [Channel]()
    var transactions = [Transaction]()
    var channel: Channel?
    var invoice : Invoice?

    override func viewDidLoad() {
        super.viewDidLoad()
        getAllChannels()
        self.navigationController?.navigationItem.title = "Novi račun"
    }

    func getAllChannels(){
        startLoading()
        DataManager.sharedInstance.getChannels(completion: { (ChannelsResponse) in
            if ChannelsResponse.success {
                
                DataManager.sharedInstance.getCards(email: (UIApplication.shared.delegate as! AppDelegate).user.email) { (CardsResponse) in
                    self.stopLoading()
                    if CardsResponse.success {
                        for i in CardsResponse.cards! {
                            print("\(i.toString())")
                        }
                    }
                }

                self.channels = ChannelsResponse.channels!
                for channel in ChannelsResponse.channels! {
                    print("\(channel.toString())")
                }
            }else{
                self.stopLoading()
            }
        })
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setVisibleNavigation(color: UIColor.dhlYellow)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == newPaymentSegueId {
            let newPaymentController = segue.destination as! NewPaymentViewController
            newPaymentController.user = self.user
            newPaymentController.invoice = self.invoice
        }
        else if segue.identifier == viewCardsSegueId {
            let cardsVC = segue.destination as! CardsViewController
            let mainVC = sender as! MainViewController
            cardsVC.channel = mainVC.channel
            cardsVC.user = mainVC.user
        }
//        else if segue.identifier == viewTransactionsId {
//            let transactionsVC = segue.destination as! TransactionsViewController
//            let mainVC = sender as! MainViewController
//            transactionsVC.transactions = mainVC.transactions
//        }
            
        else if segue.identifier == scanQRCodeSegueId {
            if let destVC = segue.destination as? QRReader {
                destVC.delegate = self
            }
        }
    }
    
    @IBAction func scanQRCode(_ sender: Any) {
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) ==  AVAuthorizationStatus.authorized
        {
            // Already Authorized
            self.performSegue(withIdentifier: scanQRCodeSegueId, sender: self)
        }
        else
        {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted :Bool) -> Void in
                if granted == true
                {
                    // User granted
                    DispatchQueue.main.async {
                        print("User granted")
                        self.performSegue(withIdentifier: self.scanQRCodeSegueId, sender: self)
                    }
                }
                else
                {
                    // User Rejected
                    print("User rejected")
                    self.showSettingsAlert(title: "Camera not allowed", message: "Please allow camera usage in order to scan QR code")
                }
            });
        }
    }
    
    @IBAction func viewCards(_ sender: UIButton) {
        
        let channel = self.channels.filter{ $0.channelName == "PARENT" }.first

        if let channel = channel {
            
            self.channel = channel
            
            performSegue(withIdentifier: viewCardsSegueId, sender: self)
        }
    }
    
//    @IBAction func makePayment(_ sender: Any) {
//        performSegue(withIdentifier: newPaymentSegueId, sender: user)
//    }
    
    @IBAction func viewTransactions(_ sender: UIButton) {
        performSegue(withIdentifier: viewTransactionsId, sender: self)
    }
}

extension MainViewController : QRReaderDelegate {
    func scannedQRString(_ string: String) {
        let invoice = Invoice(qrCodeString: string, separationCharacter: ["|"])
        self.invoice = invoice
//        self.showAlert(title: "Invoice", message: invoice.description)
        self.performSegue(withIdentifier: newPaymentSegueId, sender: self)
    }
}

