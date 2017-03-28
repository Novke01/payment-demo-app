//
//  Card.swift
//  PaymentModuleDemoApp
//
//  Created by Marko Stajic on 3/21/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import Foundation
import ObjectMapper

public class Card: NSObject, Mappable {
    var token : String = ""
    var holder : String = ""
    var monthExp : String = ""
    var yearExp : String = ""
    var last4Digits : String = ""
    var brand : String?
    var userId : String?
    var merchantChannel : String?
    var checkoutId : String = ""
    var timestamp: TimeInterval = 0
    
    override init() {
    }
    
    init(token:String,  holder: String, monthExp: String, yearExp: String, last4Digits: String, brand: String, userId: String, merchantChannel: String, checkoutId: String, timestamp: TimeInterval){
        self.token = token
        self.holder = holder
        self.monthExp = monthExp
        self.yearExp = yearExp
        self.last4Digits = last4Digits
        self.brand = brand
        self.userId = userId
        self.merchantChannel = merchantChannel
        self.checkoutId = checkoutId
        self.timestamp = timestamp

    }
    
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        token <- map["token"]
        holder <- map["holder"]
        monthExp <- map["month_exp"]
        yearExp <- map["year_exp"]
        last4Digits <- map["last_4_digits"]
        brand <- map["brand"]
        userId <- map["user_uid"]
        merchantChannel <- map["merchant_channel"]
        checkoutId <- map["checkoutId"]
        timestamp <- map["timestamp"]
    }
    
    public func toString() -> String{
        return "\nCard: \(String(describing: brand))\nLast four digits: \(last4Digits)\nExp data: \(monthExp)/\(yearExp)"
    }
    
}
