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
    let addNewCardSegueId = "goToAddNewCard"
    let scanQRCodeSegueId = "goToScanQRCode"
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var user: User!
    var checkoutId = ""
    var channels = [Channel]()
    var invoice : Invoice?

    override func viewDidLoad() {
        super.viewDidLoad()
        getAllChannels()
        
    }

    func getAllChannels(){
        DataManager.sharedInstance.getChannels(completion: { (ChannelsResponse) in
            if ChannelsResponse.success {
                self.channels = ChannelsResponse.channels!
                for channel in ChannelsResponse.channels! {
                    print("\(channel.toString())")
                }
            }
        })
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
        else if segue.identifier == addNewCardSegueId {
            if let destVC = segue.destination as? NewCardViewController {
                destVC.checkoutId = self.checkoutId
            }
        }
        else if segue.identifier == scanQRCodeSegueId {
            if let destVC = segue.destination as? QRReader {
                destVC.delegate = self
            }
        }
    }
    
    @IBAction func scanQRCode(_ sender: UIBarButtonItem) {
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
    
    @IBAction func addNewCard(_ sender: UIButton) {
        
        let channel = self.channels.filter{ $0.channelName == "PARENT" }.first

        if let channel = channel {
            
            DataManager.sharedInstance.addCard(channel: channel, completion: { (checkoutId) in
                if let id = checkoutId {
                    print("Checkout id: \(id)")
                    
                    DispatchQueue.main.sync {
                        
                        self.checkoutId = id
                        self.performSegue(withIdentifier: self.addNewCardSegueId, sender: self)
                        
                    }
                }
            })
        }
    }
    
    @IBAction func makePayment(_ sender: Any) {
        performSegue(withIdentifier: newPaymentSegueId, sender: user)
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

