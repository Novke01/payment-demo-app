//
//  Data Extensions.swift
//  PaymentModuleDemoApp
//
//  Created by Marko Stajic on 3/20/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import Foundation

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
