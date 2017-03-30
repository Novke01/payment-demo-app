//
//  RegistrationViewController.swift
//  PaymentModuleDemoApp
//
//  Created by Marko Stajic on 3/29/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import UIKit

class RegistrationViewController: BaseViewController {
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    let MyKeychainWrapper = KeychainWrapper()
    
    @IBOutlet weak var signInButton: UIButton!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let paymentDemoSegueId = "goToPaymentDemo"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.layer.cornerRadius = 10.0
        self.navigationItem.hidesBackButton = true
        self.view.backgroundColor = UIColor.dhlYellow
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    @IBAction func backToLogin(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signIn(_ sender: Any) {
        if let name = nameTextField.text, let email = emailTextField.text, let phone = phoneTextField.text {
                
                //Take identifier for vendor instead of imei
                let identifier = UIDevice.current.identifierForVendor?.uuidString
                print("UUID String: \(String(describing: identifier))")
                
                let user = User(email: email, imei: "355330084909367", name: name, phone: phone)
                
                print("••• PUSH TOKEN: \(appDelegate.firebasePushToken) •••")
            
            startLoading()
            DataManager.sharedInstance.register(user: user, completion: { (GeneralResponse) in
                self.stopLoading()
                if GeneralResponse.success {
                    self.showAlertAndGoBack(title: "Registracija uspela", message: "Email sa PIN kodom će uskoro biti poslat")
                }else{
                    self.showAlert(title: "Registracija nije uspela", message: "Nešto nije u redu")
                }
            })
        }
        
    }
}
