//
//  NewCardViewController.swift
//  PaymentModuleDemoApp
//
//  Created by Marko Stajic on 3/21/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import UIKit

class NewCardViewController: UIViewController {

    @IBOutlet weak var addNewCardWebView: UIWebView!
    var webString : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jString = "<script src=\"\(webString)\"></script></head>"
            + "<body><h1 class=\"form-title font-regular text-center\">Add New Card</h1><br />"
            + "<form action=\"\" class=\"paymentWidgets\">VISA MASTER MAESTRO</form></body>"
        addNewCardWebView.loadHTMLString(jString, baseURL: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
