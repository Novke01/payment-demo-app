//
//  Channel.swift
//  PaymentModuleDemoApp
//
//  Created by Marko Stajic on 3/21/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import Foundation
import ObjectMapper


public class Channel: NSObject, Mappable {
    var entityId : String = ""
    var userId : String = ""
    var password : String = ""
    var channelName : String = ""
    
    override init() {
    }
    
    init(entityId: String, userId: String, password: String, channelName: String){
        self.entityId = entityId
        self.userId = userId
        self.password = password
        self.channelName = channelName
    }
    
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        entityId <- map["entityId"]
        userId <- map["userId"]
        password <- map["password"]
        channelName <- map["channelName"]
    }
    
    public func toString() -> String{
        return "\nChannel: \(channelName)\nUser ID: \(userId)\nEntity Id: \(entityId)\nPassword: \(password)"
    }
    
}
