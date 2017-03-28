//
//  BaseViewController.swift
//  PaymentModuleDemoApp
//
//  Created by Aleksandar Novakovic on 3/20/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        configAllTextFields(view: view)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showSettingsAlert(title: String, message: String){
        let cameraUsageAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let settingsAction = UIAlertAction(title: "Settings", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            print("Settings")
            UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        cameraUsageAlert.addAction(cancelAction)
        cameraUsageAlert.addAction(settingsAction)
        self.present(cameraUsageAlert, animated: true, completion: nil)
    }
    
    func setInvisibleNavigation(color: UIColor){
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.barTintColor = color
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    func configAllTextFields(view: UIView) {
        for subview in view.subviews {
            if let textField = subview as? UITextField {
                let border = CALayer()
                let width = CGFloat(2.0)
                border.borderColor = UIColor.gray.cgColor
                border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
                
                border.borderWidth = width
                textField.layer.addSublayer(border)
                textField.layer.masksToBounds = true
            }
            else {
                configAllTextFields(view: subview)
            }
        }
    }
    
}
