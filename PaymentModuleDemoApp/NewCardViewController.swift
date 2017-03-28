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
        
//        checkoutId = "7ED9DEA5CAA535EA5EEE373F8B08D9BC.sbg-vm-tx01"
        
        
        
//        let css = self.cssCode()
//        let divC = self.divCode()
//        
        print("• • CHECKOUT ID: \(checkoutId!) • •")
//
//        let webString = css + "<script src=\"https://test.oppwa.com/v1/paymentWidgets.js?checkoutId=\(checkoutId)\"></script></head>"
//            + "<body><h1 class=\"form-title font-regular text-center\">Add New Card</h1><br />"
//            + "<form action=\"http://mdhl.cloudapp.net/securepay/shopperResultUrl\" class=\"paymentWidgets\">VISA MASTER MAESTRO</form>"
//            + divC + "</body>"
//        
//        _ = self.webView?.loadHTMLString(webString, baseURL: nil)

        
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
    
    func cssCode() -> String {
        let css = "<head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"><script src=\"https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js\"></script><style type=\"text/css\">html, body, div, span, applet, object, iframe,h1, h2, h3, h4, h5, h6, p, blockquote, pre,a, abbr, acronym, address, big, cite, code,del, dfn, em, img, ins, kbd, q, s, samp,small, strike, strong, sub, sup, tt, var,b, u, i, center,dl, dt, dd, ol, ul, li,fieldset, form, label, legend,table, caption, tbody, tfoot, thead, tr, th, td,article, aside, canvas, details, embed,figure, figcaption, footer, header, hgroup,menu, nav, output, ruby, section, summary,time, mark, audio, video {margin: 0;padding: 0;border: 0;font-size: 100%;vertical-align: baseline;}body {line-height: 1;min-height: 100%;background-color: white;padding-top: 50px;}* {font-family: \"SF UI Display Regular\", sans-serif;color: #0d3751;}img {max-width: 100%;}h1 {font-size: 2.4rem;}p {font-size: 1.2rem;color: #0d3751;}.font-extra-light {font-weight: 200;}.font-light {font-weight: 300;}.font-regular {font-weight: 400;}.font-medium {font-weight: 500;}.font-heavy {font-weight: 700;}.font-extra-heavy {font-weight: 800;}/**Positioning*/.float-right {float: right;}.text-center {text-align: center;}/***Securepay default styles*/.cnpBillingCheckoutWrapper { position:relative; }.cnpBillingCheckoutHeader { width:100%;border-bottom: 1px solid #c0c0c0;margin-bottom:10px; }.cnpBillingCheckoutLeft { width:240px;margin-left: 5px;margin-bottom: 10px;border: 1px solid #c0c0c0;display:inline-block;vertical-align: top;padding:10px; }.cnpBillingCheckoutRight { width:50%;margin-left: 5px;border: 1px solid #c0c0c0;display:inline-block;vertical-align: top;padding:10px; }.cnpBillingCheckoutOrange { font-size:110%;color: rgb(255, 60, 22);font-weight:bold; }div.wpwl-wrapper, div.wpwl-label, div.wpwl-sup-wrapper { width: 100% }div.wpwl-group-expiry, div.wpwl-group-brand { width: 30%; float:left }div.wpwl-group-cvv { width: 68%; float:left; margin-left:2% }div.wpwl-group-cardHolder, div.wpwl-sup-wrapper-street1, div.wpwl-group-expiry { clear:both }div.wpwl-sup-wrapper-street1 { padding-top: 1px }div.wpwl-wrapper-brand { width: auto }div.wpwl-sup-wrapper-state, div.wpwl-sup-wrapper-city { width:32%;float:left;margin-right:2% }div.wpwl-sup-wrapper-postcode { width:32%;float:left }div.wpwl-sup-wrapper-country { width: 66% }div.wpwl-wrapper-brand, div.wpwl-label-brand, div.wpwl-brand { display: none;}div.wpwl-brand-card  { width: 65px }div.wpwl-brand-custom  { margin: 0px 5px; background-image: url(\"https://oppwa.com/v1/paymentWidgets/img/brand.png\") }/**Add card form*/.wpwl-container {height: auto;width: 100%;background-color: white;}.wpwl-form {margin: 30px auto 5px auto;}.wpwl-form,h1.form-title,.credit-card-info {max-width: 375px;width: 80%;}.credit-card-info {margin: 0 auto;}h1.form-title,h1.credit-card-info--title {font-size: 1.4rem;margin: 0 auto;}.credit-card-info--text {text-align: justify;font-size: 0.8rem;margin-top: 15px;}.wpwl-wrapper {margin-bottom: 15px;}form:not(.wpwl-form),form:not(.wpwl-form) input {padding: 0 !important;}.card-number-placeholder {font-size: 16px;}.wpwl-group-cardNumber {width: 100%;display: inline-block;position: relative;}.wpwl-control-givenName, .wpwl-control-surName {width: 100%;}.wpwl-group-expiry {float: left;}.wpwl-group-expiry,.wpwl-group-cvv {width: 48% !important;}.wpwl-group-cvv {float: right !important;margin-left: 0 !important;}.wpwl-control-givenName {margin-bottom: 25px;}.wpwl-control {border: none;border-bottom: 1px solid #c8cdd1;background-color: transparent;padding: 0 !important;}.wpwl-group-brand {width: 20% !important;position: absolute;right: 0;top: 0;}div.wpwl-brand-card {float: left !important;}.wpwl-brand-MASTER {margin: 0;right: -15px;}.wpwl-brand-custom {position: absolute;margin: 0 5px;display: none;}.wpwl-brand-VISA {margin-top: 5px !important;height: 23px;right: -5px;}.wpwl-brand-MAESTRO {margin-top: 6px !important;}.wpwl-wrapper-cvv .wpwl-icon {background: none;border-radius: 25px;border-color: #717f88;}input {font-size: 16px;}.wpwl-wrapper-submit {padding-top: 15px;}.wpwl-group-submit {clear: both;}.wpwl-button {width: 100%;background-color: #68b72c;height: 60px;font-size: 1.4rem;border-radius: 3px;}.all-secure-logo {width: 40%;margin-top: 15px;}.secure-logos {width: 60%;}span.payments-processed {font-size: 0.7rem;display: inline-block;margin-top: -35px;vertical-align: middle;}.unicredit-logo {width: 50%;margin-left: 5px;}</style><script>var brandIconsLoaded = false;var wpwlOptions = {style: \"plain\",showLabels: false,forceCardHolderEqualsBillingName: false,showCVVHint: true,brandDetection: true,iframeStyles: {'card-number-placeholder': {'padding-left': '0px','display': 'none'}},onReady: function() {var visa = $(\".wpwl-brand:first\").clone().removeAttr(\"class\").attr(\"class\", \"wpwl-brand-card wpwl-brand-custom wpwl-brand-VISA\");var master = $(visa).clone().removeClass(\"wpwl-brand-VISA\").addClass(\"wpwl-brand-MASTER\");var maestro = $(visa).clone().removeClass(\"wpwl-brand-VISA\").addClass(\"wpwl-brand-MAESTRO\");$(\".wpwl-brand:first\").after($(maestro)).after($(master)).after($(visa));var cardHolderGroup = $(\".wpwl-group-cardHolder\").detach();$(\".wpwl-form\").prepend(cardHolderGroup);var cardBrandGroup = $(\".wpwl-group-brand\").detach();$(\".wpwl-group-submit\").before(cardBrandGroup);var brandDetectGroup = $(\".wpwl-group-brand\").detach();$(\".wpwl-group-cardNumber\").append(brandDetectGroup);$(\".wpwl-brand-VISA:not(.wpwl-brand-custom)\").remove();brandIconsLoaded = true;$(\".wpwl-control-cardNumber\").attr(\"placeholder\", \"Card Number 1234-5678-9012-3456\");$(\".wpwl-control-expiry\").attr(\"placeholder\", \"Expiry date MM/YY\");$(\".wpwl-button\").text(\"Authorize\");},onChangeBrand: function(e) {if(!brandIconsLoaded) return;$(\".wpwl-brand-custom\").css(\"display\", \"none\");$(\".wpwl-brand-\" + e).css(\"display\", \"block\");}};</script>"
        
        return css
    }
    
    private func divCode() -> String {
        
        return "<div class=\"credit-card-info\"><h1 class=\"credit-card-info--title font-regular text-center\">Credit card authorization</h1><p class=\"credit-card-info--text\">" + "Authorization info message" + "</p><img class=\"all-secure-logo\" src=\"" + "\"><img class=\"secure-logos\" src=\"" + "\"><div class=\"text-center\"><span class=\"payments-processed\">Payments processed by</span><img class=\"unicredit-logo\" src=\"" + "\"></div></div>"
    }

}
