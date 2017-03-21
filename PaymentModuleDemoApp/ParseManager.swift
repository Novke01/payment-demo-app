//
//  ParseManager.swift
//  Dms
//
//  Created by Marko Stajic on 12/2/16.
//  Copyright © 2016 DMS. All rights reserved.
//

import Foundation
import ObjectMapper

public class ParseManager {
    
    // MARK: - Properties
    open static let sharedInstance = ParseManager()
    let defaults = UserDefaults.standard
    
    // MARK: - Lifecycle
    init() {
    }
    
    open func parseUser(_ jsonDictionary: [String:Any]) -> User? {
        if let user = Mapper<User>().map(JSONObject: jsonDictionary){
            return user
        }else{
            return nil
        }
    }
}

