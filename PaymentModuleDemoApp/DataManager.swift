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
    public func login(email: String, pin: String, pushToken: String, imei: String, completion: @escaping (LoginResponse)->Void){
        
        let url = API.login
        let parameters = ["pin":pin, "uid": email, "pushToken": pushToken, "imei": imei]
        
        RestManager.sharedInstance.POST(url: url, parameters: parameters, completion: { (json, data, success) in
            
            if success {
                if let jsonData = json, let jsonDictionary = jsonData as? [String:Any] {
                    
                    if let code = jsonDictionary["code"] as? Int, let message = jsonDictionary["message"] as? String {
                        if Array(200..<300).contains(code) {
                            
                            if let data = jsonDictionary["data"] as? [String:Any], let token = data["token"] as? String, let userJSON = data["user"] as? [String: Any], let user = ParseManager.sharedInstance.parseUser(userJSON) {
                                
                                print("• AUTH Token: \(token) •")
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
    
    ///Get user transactions
    public func getTransactions(email: String, page: Int, transactionCount: Int, completion: @escaping (TransactionsResponse)->Void){
        let url = API.transactions + "/\(email)/\(page)/\(transactionCount)"
        
        RestManager.sharedInstance.GET(url: url) { (json, data, success) in
            
            if success {
                if let jsonData = json, let jsonDictionary = jsonData as? [String:Any] {
                    
                    if let code = jsonDictionary["code"] as? Int, let message = jsonDictionary["message"] as? String {
                        if Array(200..<300).contains(code) {
                            if let jsonArray = jsonDictionary["data"] as? [[String:Any]], let transactions = ParseManager.sharedInstance.parseTransactions(jsonArray) {
                                completion(TransactionsResponse(success: true, transacations: transactions, error: nil, message: "Ok"))
                            }else{
                                completion(TransactionsResponse(success: false, transacations: nil, error: nil, message: "Nije dobro"))
                            }
                        }else{
                            completion(TransactionsResponse(success: false, transacations: nil, error: nil, message: "Transactions getting fail reason: \(message), Error code: \(code)"))
                        }
                    }else{
                        completion(TransactionsResponse(success: false, transacations: nil, error: nil, message: "Transactions getting failed"))
                    }
                }else{
                    completion(TransactionsResponse(success: false, transacations: nil, error: nil, message: "Response not parsed"))
                }
            }else{
                completion(TransactionsResponse(success: false, transacations: nil, error: nil, message: "HTTP Request failed"))
            }
        }
    }
    
    ///Get user transaction status
    public func getTransactionByTrackingId(trackingId: String, completion: @escaping (TransactionResponse)->Void){
        let url = API.transaction + "/\(trackingId)/status"
        
        RestManager.sharedInstance.GET(url: url) { (json, data, success) in
            
            if success {
                if let jsonData = json, let jsonDictionary = jsonData as? [String:Any] {
                    
                    if let code = jsonDictionary["code"] as? Int, let message = jsonDictionary["message"] as? String {
                        if Array(200..<300).contains(code) {
                            if let jsonArray = jsonDictionary["data"] as? [String:Any], let transaction = ParseManager.sharedInstance.parseTransaction(jsonArray) {
                                completion(TransactionResponse(success: true, transaction: transaction, error: nil, message: "Ok"))
                            }else{
                                completion(TransactionResponse(success: false, transaction: nil, error: nil, message: "Nije dobro"))
                            }
                        }else{
                            completion(TransactionResponse(success: false, transaction: nil, error: nil, message: "Transaction getting fail reason: \(message), Error code: \(code)"))
                        }
                    }else{
                        completion(TransactionResponse(success: false, transaction: nil, error: nil, message: "Transaction getting failed"))
                    }
                }else{
                    completion(TransactionResponse(success: false, transaction: nil, error: nil, message: "Response not parsed"))
                }
            }else{
                completion(TransactionResponse(success: false, transaction: nil, error: nil, message: "HTTP Request failed"))
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
    public func addCard(channel: Channel, completion: @escaping (_ checkoutId: String?)->Void){
        let url = API.allSecureCheckout
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let postBody = ""
            + "authentication.userId=\(channel.userId)"
            + "&authentication.password=\(channel.password)"
            + "&authentication.entityId=\(channel.entityId)"
            + "&createRegistration=true"
            + "&customParameters[SHOPPER_customerId]=\(appDelegate.user.email)"
            + "&customParameters[SHOPPER_action]=createCard"
            + "&customer.merchantCustomerId=\(appDelegate.user.email)"
            + "&customer.email=\(appDelegate.user.email)"
            + "&amount=1.00"
            + "&currency=RSD"
            + "&paymentType=PA"
            + "&billing.postcode=21000"
            + "&billing.country=RS"

        
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        
        request.httpBody = postBody.data(using: String.Encoding.utf8)
        
        print("• ADD NEW CARD\n: \(request.debugDescription)\n•")
        print("ADD CARD BODY:")
        print(NSString(data: request.httpBody!, encoding:String.Encoding.utf8.rawValue)!)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            do {
                let json : [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any]
                
                print("Add new card response: \n\(json)\n")
                
                if let checkOutId = json["id"] as? String {
                    completion(checkOutId)
                }else{
                    completion(nil)
                }
                
            }catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
        
    }
    
    public func removeCard(cardId: String, completion: @escaping (GeneralResponse) -> Void) {
        let url = API.removeCard + "?cardID=" + cardId
        
        RestManager.sharedInstance.PUT(url: url, completion: { (json, data, success) -> Void in
            if success {
                if let jsonData = json, let jsonDictionary = jsonData as? [String: Any] {
                    if let code = jsonDictionary["code"] as? Int, let message = jsonDictionary["message"] as? String {
                        if Array(200..<300).contains(code) {
                            completion(GeneralResponse(success: true, error: nil, message: message))
                        }
                    }
                }
            }
        })
        
    }
    
    //One click payment
    public func oneClickPayment(billId: String, price: String, currency: String, card: String, completion: @escaping (GeneralResponse)->Void) {
        
        let url = API.oneClickPay
        let parameters = ["amount":price, "track_id": billId, "cart_price": price, "currency": currency, "card_token": card, "user_uid":(UIApplication.shared.delegate as! AppDelegate).user.email, "shipping_postcode":"", "description": "DHL Paket", "delivery_boy":0] as [String : Any]
        
        RestManager.sharedInstance.POST(url: url, parameters: parameters, completion: { (json, data, success) in
            
            if success {
                if let jsonData = json, let jsonDictionary = jsonData as? [String:Any] {
                    
                    if let code = jsonDictionary["code"] as? Int, let message = jsonDictionary["message"] as? String {
                        if Array(200..<300).contains(code) {
                            
                            if let data = jsonDictionary["data"] as? [String:Any] {
                                
                                print("• One click payment: \(data) •")
                                completion(GeneralResponse(success: true, error: nil, message: message))
                            }else{
                                completion(GeneralResponse(success: false, error: nil, message: "One click payment data not parsed"))
                            }
                        }else{
                            completion(GeneralResponse(success: false, error: nil, message: "One click payment fail reason: \(message), Error code: \(code)"))
                        }
                    }else{
                        completion(GeneralResponse(success: false, error: nil, message: "One click payment failed"))
                    }
                }else{
                    completion(GeneralResponse(success: false, error: nil, message: "Response not parsed"))
                }
            }else{
                completion(GeneralResponse(success: false, error: nil, message: "HTTP Request failed"))
            }
        })

        
    }
    
    // Send push token.
    public func sendPushToken(pushToken: String, userEmail: String, completion: @escaping (GeneralResponse) -> Void) {
        let url = API.sendPushToken
        let parameters = ["pushToken": pushToken, "uid": userEmail]
        
        RestManager.sharedInstance.PUT(url: url, parameters: parameters, completion: { (json, data, success) in
            if success {
                if let jsonData = json, let jsonDictionary = jsonData as? [String: Any] {
                    if let code = jsonDictionary["code"] as? Int, let message = jsonDictionary["message"] as? String {
                        if Array(200..<300).contains(code) {
                            completion(GeneralResponse(success: true, error: nil, message: message))
                        }
                    }
                }
            }
        })
        
    }
    
    public func getWebView(checkoutId: String, completion: @escaping (_ webString: String?)->Void){
        
        let url = API.allSecurePaymentWidget + "?checkoutId=\(checkoutId)"
        print("URL: \(url)")
        
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
//        request.httpBody = postBody.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            if let responseString = String(data: data!, encoding: String.Encoding.utf8) {
                completion(responseString)
            }else{
                completion(nil)
            }
        }
        task.resume()
    }

}

