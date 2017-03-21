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
    open func parseCards(_ jsonArray: [[String:Any]]) -> [Card]? {
        var cards = [Card]()
        for json in jsonArray {
            if let card = Mapper<Card>().map(JSONObject: json){
                cards.append(card)
            }
        }
        return cards.count>0 ? cards:nil
    }
    open func parseChannels(_ jsonArray: [[String:Any]]) -> [Channel]? {
        var channels = [Channel]()
        for json in jsonArray {
            if let channel = Mapper<Channel>().map(JSONObject: json){
                channels.append(channel)
            }
        }
        return channels.count>0 ? channels:nil
    }

}

