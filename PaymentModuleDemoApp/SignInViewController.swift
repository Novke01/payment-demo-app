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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
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
                let user = User(email: email, imei: "355330084909367", name: "Marko Stajic", phone: "+38166066068")
                DataManager.sharedInstance.login(user: user, pin: pin, pushToken: appDelegate.instanceToken, completion: { loginResponse in
                    if loginResponse.success {
                        (UIApplication.shared.delegate as! AppDelegate).user = loginResponse.user!
<<<<<<< HEAD
                        print("\(loginResponse.user!.toString())")
                        self.performSegue(withIdentifier: self.paymentDemoSegueId, sender: loginResponse.user!)
                        self.saveCredentials(email: user.email, pin: pin)
=======
                        print("USER: \(loginResponse.user!.toString())")
                        
                        DataManager.sharedInstance.sendPushToken(pushToken: self.appDelegate.instanceToken!, userEmail: user.email, completion: { generalResponse in
                            print("SEND PUSH TOKEN: \(generalResponse)")
                            if generalResponse.success {
                                self.performSegue(withIdentifier: self.paymentDemoSegueId, sender: loginResponse.user!)
                            }
                            else {
                                print("Error: \(generalResponse.message) ")
                            }
                        })
>>>>>>> c853bad1a7b90e4c14320d84d51db11d6f922cf4
                        
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

extension UITextField {
    func setDoneToolbar(){
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let toolbarRightButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(resignFirstResponder))
        toolbarRightButton.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 17.0)], for: UIControlState.normal)
        toolbar.barTintColor = UIColor.orange
        toolbar.isTranslucent = false
        
        toolbarRightButton.tintColor = UIColor.white
        toolbar.items = [flexibleSpace, toolbarRightButton]
        inputAccessoryView = toolbar
    }
}
