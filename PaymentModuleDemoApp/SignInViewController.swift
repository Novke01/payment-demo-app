//
//  SignInViewController.swift
//  PaymentModuleDemoApp
//
//  Created by Aleksandar Novakovic on 3/20/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import UIKit

class SignInViewController: BaseViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pinTextField: UITextField!
    let MyKeychainWrapper = KeychainWrapper()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let paymentDemoSegueId = "goToPaymentDemo"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.dhlYellow
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setInvisibleNavigation(color: UIColor.dhlYellow)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == paymentDemoSegueId {
            let mainViewController = segue.destination as! MainViewController
            mainViewController.user = sender as! User
        }
    }
    
    func saveCredentials(email: String, pin: String){
        MyKeychainWrapper.mySetObject(pin, forKey: kSecValueData)
        // 5.
        MyKeychainWrapper.writeToKeychain()
        UserDefaults.standard.set(true, forKey: "hasLoginKey")
    }
    
    @IBAction func signIn(_ sender: Any) {
        if let email = emailTextField.text {
            if let pin = pinTextField.text {
                
                //Take identifier for vendor instead of imei
                let identifier = UIDevice.current.identifierForVendor?.uuidString
                print("UUID String: \(identifier)")
                
//                let user = User(email: email, imei: identifier ?? "355330084909367", name: "Marko Stajic", phone: "+38166066068")
                let user = User(email: email, imei: "355330084909367", name: "Marko Stajic", phone: "+38166066068")

                DataManager.sharedInstance.login(user: user, pin: pin, pushToken: appDelegate.instanceToken, completion: { loginResponse in
                    if loginResponse.success {
                        (UIApplication.shared.delegate as! AppDelegate).user = loginResponse.user!

                        print("USER: \(loginResponse.user!.toString())")
                        
                        DataManager.sharedInstance.sendPushToken(pushToken: self.appDelegate.instanceToken, userEmail: user.email, completion: { generalResponse in
                            print("SEND PUSH TOKEN: \(generalResponse)")
                            if generalResponse.success {
                                self.saveCredentials(email: user.email, pin: pin)
                                self.performSegue(withIdentifier: self.paymentDemoSegueId, sender: loginResponse.user!)
                            }
                            else {
                                print("Error: \(generalResponse.message) ")
                            }
                        })
                    }
                    else {
                        print("Error: \(loginResponse.message)")
                        self.showAlert(title: "Prijavljivanje nije uspelo", message: loginResponse.message)
                    }
                })
            }
        }
        
    }
}
