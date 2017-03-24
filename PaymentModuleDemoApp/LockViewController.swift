//
//  LockViewController.swift
//  PaymentModuleDemoApp
//
//  Created by Marko Stajic on 3/24/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import UIKit
import LocalAuthentication

class LockViewController: BaseViewController {

    var context = LAContext()
    @IBOutlet weak var touchIDButton: UIButton!
    @IBOutlet weak var pinCodeTextField: UITextField!
    let MyKeychainWrapper = KeychainWrapper()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "App Lock"
        touchIDButton.isHidden = true
        pinCodeTextField.setDoneToolbar()
        
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            touchIDButton.isHidden = false
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginWithTouchId(_ sender: UIButton) {
        
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error:nil) {
            
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Please place your finger", reply: { (success, error) in
                DispatchQueue.main.async {
                    if success {
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                    if error != nil {
                        var message : String
                        
                        switch(error!._code) {
                        case LAError.authenticationFailed.rawValue:
                            message = "There was a problem verifying your identity."
                            self.showAlert(title: "Error", message: message)
                            break;
                        case LAError.userCancel.rawValue:
                            message = "You pressed cancel."
                            break;
                        case LAError.userFallback.rawValue:
                            message = "You pressed password."
                            break;
                        default:
                            message = "Touch ID may not be configured"
                            self.showAlert(title: "Error", message: message)
                            break;
                        }
                        
                    }

                }
            })
        } else {
            // 5
            self.showAlert(title: "Error", message: "Touch ID not available")
        }
        
    }

    func checkLogin(pin: String)->Bool{
    
        if pin == MyKeychainWrapper.myObject(forKey: "v_Data") as! String {
            return true
        } else {
            return false
        }
    }
}

extension LockViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            
            if text.characters.count != 4 {
                self.showAlert(title: "Pogrešan PIN", message: "PIN Kod mora sadržati 4 cifre")
            }else{
                if self.checkLogin(pin: text) {
                    dismiss(animated: true, completion: nil)
                }else{
                    showAlert(title: "Pogrešan PIN", message: "Niste uneli ispravan PIN kod")
                }
            }
        }
    }
}
