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

    let startRequestMessage = "startRequest"
    let handlerName = "requestSent"
    let backSegueId = "goBack"
    
    var webView: WKWebView?
    var checkoutId : String!
    
    override func loadView() {
        super.loadView()
        
        let webConfig = WKWebViewConfiguration()
        let userController = WKUserContentController()
        userController.add(self, name: handlerName)
        webConfig.userContentController = userController
        
        webView = WKWebView(frame: view.frame, configuration: webConfig)
        view = webView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string:"http://mdhl.cloudapp.net/allPay/pay_form_new.html")
        let js = "var android = { " +
                 "    getCheckoutId: function() { return '\(checkoutId!)'; }," +
                 "    getShopperResultUrl: function() { return 'http://mdhl.cloudapp.net/securepay/shopperResultUrl'; }," +
                 "    startRequest: function() { " +
                 "        window.webkit.messageHandlers.\(handlerName).postMessage('\(startRequestMessage)');" +
                 "        return 'startRequest';" +
                 "    }," +
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
    
    func back() {
        performSegue(withIdentifier: backSegueId, sender: nil)
    }
    
}

extension NewCardViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == handlerName {
            print("MESSAGE: " + message.name)
        }
    }
    
}
