//
//  User.swift
//  Dms
//
//  Created by Marko Stajic on 11/16/16.
//  Copyright © 2016 DMS. All rights reserved.
//

import Foundation
import ObjectMapper


public class User: NSObject, Mappable {
    var email : String = ""
    var imei : String = ""
    var name : String = ""
    var phone : String = ""
    var address : String?
    var company : String?
    var postalNumber : String?
    var number : Int?
    
    override init() {
    }
    
    init(email: String, imei: String, name: String, phone: String){
        self.email = email
        self.imei = imei
        self.name = name
        self.phone = phone
    }
    
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        email <- map["email"]
        imei <- map["imei"]
        name <- map["name"]
        phone <- map["phone"]
    }
    
    public func toString() -> String{
        return "\nUser: \(name)\nEmail: \(email)"
    }
    
}
