//
//  Transaction.swift
//  PaymentModuleDemoApp
//
//  Created by Marko Stajic on 3/21/17.
//  Copyright © 2017 Execom. All rights reserved.
//


import Foundation
import ObjectMapper

public class Transaction : NSObject, Mappable {
    
    var transactionId: String = ""
    var amount: String = ""
    var holderName: String = ""
    var last4digits: String = ""
    var brand: String = ""
    var month: String = ""
    var year:  String = ""
    var timestamp: Double = 0
    var transactionDescription: String = ""
    var trackingId: String = ""
    var status: String = ""
    var checkoutId: String = ""

    override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        transactionId <- map["transaction_id"]
        amount <- map["amount"]
        holderName <- map["holder_name"]
        last4digits <- map["last4digits"]
        brand <- map["brand"]
        month <- map["month"]
        year <- map["year"]
        timestamp <- map["timestamp"]
        transactionDescription <- map["description"]
        trackingId <- map["tracking_id"]
        status <- map["status"]
        checkoutId <- map["checkoutId"]
    }
    
    public func toString() -> String{
        return "\nTransaction: \(trackingId)\nAmount: \(amount)\nHolder name: \(holderName)\nLast four digits: \(last4digits)\nExp data: \(month)/\(year)\nTransaction description: \(transactionDescription)\nStatus: \(status)\n"
    }

}
