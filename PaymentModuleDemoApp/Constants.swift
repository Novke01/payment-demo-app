//
//  Constants.swift
//  PaymentModuleDemoApp
//
//  Created by Marko Stajic on 3/20/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import Foundation

struct API {
    static let base = "http://mdhl.cloudapp.net/MobilePaymentAPI/"
    static let login = base + "authentication/pin"
    static let register = base + "register/user"
    static let cards = base + "cards"
}
