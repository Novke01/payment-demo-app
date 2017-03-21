//
//  MainViewController.swift
//  PaymentModuleDemoApp
//
//  Created by Aleksandar Novakovic on 3/17/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var user = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = User(email: "marko.stajic@gmail.com", imei: "355330084909367", name: "Marko Stajic", phone: "+38166066068")
        
        //register:
//        DataManager.sharedInstance.register(user: user) { (GeneralResponse) in
//            if GeneralResponse.success {
//                print("\(GeneralResponse.message)")
//            }else{
//                print("Error: \(GeneralResponse.message)")
//            }
//        }
        
        //login and get cards
        DataManager.sharedInstance.login(user: user, pin: "8220", pushToken: appDelegate.deviceToken) { (LoginResponse) in
            if LoginResponse.success {
                print("\(LoginResponse.user!.toString())")
                self.user = LoginResponse.user!
                
                DataManager.sharedInstance.getCards(email: self.user.email, completion: { (GeneralResponse) in
                    print("\(GeneralResponse.message)")
                })
                
            }else{
                print("Error: \(LoginResponse.message)")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

