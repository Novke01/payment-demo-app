//
//  Constants.swift
//  PaymentModuleDemoApp
//
//  Created by Marko Stajic on 3/20/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import Foundation

struct API {
    static let mdhlBase = "http://mdhl.cloudapp.net/MobilePaymentAPI/"
    static let login = mdhlBase + "authentication/pin"
    static let register = mdhlBase + "register/user"
    static let cards = mdhlBase + "cards"
    static let channels = mdhlBase + "channels"

    static let allSecureBase = "https://test.oppwa.com/v1/"
    static let allSecureCheckout = allSecureBase + "checkouts"
    static let allSecurePaymentWidget = allSecureBase + "paymentWidgets.js"
}
