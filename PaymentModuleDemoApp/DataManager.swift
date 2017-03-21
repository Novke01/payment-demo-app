//
//  DataManager.swift
//  Dms
//
//  Created by Marko Stajic on 11/15/16.
//  Copyright © 2016 DMS. All rights reserved.
//

import Foundation
import ObjectMapper

public typealias CompletionHandlerClosureType = (_ success: Bool) -> ()

public class DataManager {
    
    let queue:DispatchQueue	= DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
    let group:DispatchGroup	= DispatchGroup()
    
    // MARK: - Properties
    open static let sharedInstance = DataManager()
    let defaults = UserDefaults.standard
    
    // MARK: - Lifecycle
    init() {
    }
    
    ///Register user
    public func register(user: User, completion: @escaping (GeneralResponse)->Void){
        
        let url = API.register
        let parameters = user.toJSON()
        
        RestManager.sharedInstance.POST(url: url, parameters: parameters, completion: { (json, data, success) in
            if success {
                if let jsonData = json, let jsonDictionary = jsonData as? [String:Any] {
                    
                    if let code = jsonDictionary["code"] as? Int, let message = jsonDictionary["message"] as? String {
                        if Array(200..<300).contains(code) {
                            completion(GeneralResponse(success: true, error: nil, message: "Registration succes: \(message)"))
                        }else{
                            completion(GeneralResponse(success: false, error: nil, message: "Registration fail reason: \(message), Error code: \(code)"))
                        }
                    }else{
                        completion(GeneralResponse(success: false, error: nil, message: "Registration failed"))
                    }
                }else{
                    completion(GeneralResponse(success: false, error: nil, message: "Response not parsed"))
                }
            }else{
                completion(GeneralResponse(success: false, error: nil, message: "HTTP Request failed"))
            }
        })
    }
    
    ///Get authentication token and put it in HTTP Request Header
    public func login(user: User, pin: String, pushToken: String, completion: @escaping (LoginResponse)->Void){
        
        let url = API.login
        let parameters = ["pin":pin, "uid": user.email, "pushToken": pushToken, "imei": user.imei]
        
        RestManager.sharedInstance.POST(url: url, parameters: parameters, completion: { (json, data, success) in
            
            if success {
                if let jsonData = json, let jsonDictionary = jsonData as? [String:Any] {
                    
                    if let code = jsonDictionary["code"] as? Int, let message = jsonDictionary["message"] as? String {
                        if Array(200..<300).contains(code) {
                            
                            if let data = jsonDictionary["data"] as? [String:Any], let token = data["token"] as? String, let userJSON = data["user"] as? [String: Any], let user = ParseManager.sharedInstance.parseUser(userJSON) {
                                RestManager.sharedInstance.updateAuthToken(token: token)
                                completion(LoginResponse(success: true, user: user, error: nil, message: message))
                            }else{
                                completion(LoginResponse(success: false, user: nil, error: nil, message: "Login data not parsed"))
                            }
                        }else{
                            completion(LoginResponse(success: false, user: nil, error: nil, message: "Login fail reason: \(message), Error code: \(code)"))
                        }
                    }else{
                        completion(LoginResponse(success: false, user: nil, error: nil, message: "Login failed"))
                    }
                }else{
                    completion(LoginResponse(success: false, user: nil, error: nil, message: "Response not parsed"))
                }
            }else{
                completion(LoginResponse(success: false, user: nil, error: nil, message: "HTTP Request failed"))
            }
        })
    }
    
    ///Get user cards
    public func getCards(email: String, completion: @escaping (CardsResponse)->Void){
        let url = API.cards + "?userUID=\(email)"
        
        RestManager.sharedInstance.GET(url: url) { (json, data, success) in
            
            if success {
                if let jsonData = json, let jsonDictionary = jsonData as? [String:Any] {
                    
                    if let code = jsonDictionary["code"] as? Int, let message = jsonDictionary["message"] as? String {
                        if Array(200..<300).contains(code) {
                            if let jsonArray = jsonDictionary["data"] as? [[String:Any]], let cards = ParseManager.sharedInstance.parseCards(jsonArray) {
                                completion(CardsResponse(success: true, cards: cards, error: nil, message: "Ok"))
                            }else{
                                completion(CardsResponse(success: false, cards: nil, error: nil, message: "Nije dobro"))
                            }
                        }else{
                            completion(CardsResponse(success: false, cards: nil, error: nil, message: "Card getting fail reason: \(message), Error code: \(code)"))
                        }
                    }else{
                        completion(CardsResponse(success: false, cards: nil, error: nil, message: "Card getting failed"))
                    }
                }else{
                    completion(CardsResponse(success: false, cards: nil, error: nil, message: "Response not parsed"))
                }
            }else{
                completion(CardsResponse(success: false, cards: nil, error: nil, message: "HTTP Request failed"))
            }
        }
    }
    
    ///Get user cards
    public func getChannels(completion: @escaping (ChannelsResponse)->Void){
        let url = API.channels
        
        RestManager.sharedInstance.GET(url: url) { (json, data, success) in
            
            if success {
                if let jsonData = json, let jsonDictionary = jsonData as? [String:Any] {
                    
                    if let code = jsonDictionary["code"] as? Int, let message = jsonDictionary["message"] as? String {
                        if Array(200..<300).contains(code) {
                            if let jsonArray = jsonDictionary["data"] as? [[String:Any]], let channels = ParseManager.sharedInstance.parseChannels(jsonArray) {
                                completion(ChannelsResponse(success: true, channels: channels, error: nil, message: "Ok"))
                            }else{
                                completion(ChannelsResponse(success: false, channels: nil, error: nil, message: "Nije dobro"))
                            }
                        }else{
                            completion(ChannelsResponse(success: false, channels: nil, error: nil, message: "Card getting fail reason: \(message), Error code: \(code)"))
                        }
                    }else{
                        completion(ChannelsResponse(success: false, channels: nil, error: nil, message: "Card getting failed"))
                    }
                }else{
                    completion(ChannelsResponse(success: false, channels: nil, error: nil, message: "Response not parsed"))
                }
            }else{
                completion(ChannelsResponse(success: false, channels: nil, error: nil, message: "HTTP Request failed"))
            }
        }
    }

    
    ///Add new card
    public func addCard(email: String, completion: @escaping (CardsResponse)->Void){
        let url = API.cards + "?userUID=\(email)"
        
//            + "authentication.userId=\(self.userId)"
//            + "&authentication.password=\(self.password)"
//            + "&authentication.entityId=\(self.entityIdTopLavel)"
//            + "&amount=\(Constants.minAmountForPA)"
//            + "&currency=\(Constants.paCurrency)"
//            + "&paymentType=\(self.paymentType)"
//            + "&createRegistration=true"
//            + "&customParameters[accidentId]=\(accidentIDifNUll)"
//            + "&customParameters[userId]=\(Preferences().GetUserId()!)"
//
        
        RestManager.sharedInstance.GET(url: url) { (json, data, success) in
            
            if success {
                if let jsonData = json, let jsonDictionary = jsonData as? [String:Any] {
                    
                    if let code = jsonDictionary["code"] as? Int, let message = jsonDictionary["message"] as? String {
                        if Array(200..<300).contains(code) {
                            if let jsonArray = jsonDictionary["data"] as? [[String:Any]], let cards = ParseManager.sharedInstance.parseCards(jsonArray) {
                                completion(CardsResponse(success: true, cards: cards, error: nil, message: "Ok"))
                            }else{
                                completion(CardsResponse(success: false, cards: nil, error: nil, message: "Nije dobro"))
                            }
                        }else{
                            completion(CardsResponse(success: false, cards: nil, error: nil, message: "Card getting fail reason: \(message), Error code: \(code)"))
                        }
                    }else{
                        completion(CardsResponse(success: false, cards: nil, error: nil, message: "Card getting failed"))
                    }
                }else{
                    completion(CardsResponse(success: false, cards: nil, error: nil, message: "Response not parsed"))
                }
            }else{
                completion(CardsResponse(success: false, cards: nil, error: nil, message: "HTTP Request failed"))
            }
        }
    }

}

