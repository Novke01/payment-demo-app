//
//  NewCardViewController.swift
//  PaymentModuleDemoApp
//
//  Created by Marko Stajic on 3/21/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import UIKit
import WebKit

class NewCardViewController: UIViewController {

    var webView: WKWebView?
    var checkoutId : String!
    
    override func loadView() {
        super.loadView()
        
        webView = WKWebView()
        view = webView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        checkoutId = "E1D80D156CA242D1B192F99ACC0824FE.sbg-vm-tx01"
        
        let url = URL(string:"http://mdhl.cloudapp.net/allPay/pay_form_new.html")
        let js = "var android = { " +
                 "    getCheckoutId: function() { return '\(checkoutId!)'; }," +
                 "    getShopperResultUrl: function() { return 'http://mdhl.cloudapp.net/securepay/shopperResultUrl'; }," +
                 "    startRequest: function() { return 'startRequest'; }," +
                 "    fullPageLoaded: function() { return 'fullPageLoaded'; }" +
                 "};"
        let req = URLRequest(url:url!)
        
        
        let _ = webView?.load(req)
        
        webView?.evaluateJavaScript(js, completionHandler: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
