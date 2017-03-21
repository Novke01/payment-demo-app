//
//  RestManager.swift
//  Dms
//
//  Created by Marko Stajic on 11/15/16.
//  Copyright © 2016 DMS. All rights reserved.
//

import Alamofire
import ObjectMapper

// TODO: delete public after testing

/// Class communicates with server. Contains all functions needed for communication with server.
/// It is used by DataManager.swift
class RestManager {
    
    static let sharedInstance = RestManager()
    private let manager: Alamofire.SessionManager
    var headers : HTTPHeaders!
    var authorizationToken = ""
    
    // MARK: - Lifcycle
    init() {
        
        // Alamofire request configuration
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 15
        let cooks = HTTPCookieStorage.shared
        
        configuration.httpCookieStorage = cooks
        configuration.httpCookieAcceptPolicy = HTTPCookie.AcceptPolicy.always
        manager = Alamofire.SessionManager(configuration: configuration)
        
        headers = [
            "Authorization": authorizationToken,
            "Accept": "application/json"
        ]
        
    }
    
    public func updateAuthToken(token: String) {
        authorizationToken = token
        
        print("Headers: \(headers)")
        headers = [
            "Authorization": authorizationToken,
            "Accept": "application/json"
        ]

    }
    
    func POST(url: String, parameters: [String:Any]?=nil, completion: @escaping (_ json: Any?, _ errorData: Data?, _ success: Bool) -> ()) {
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        
        self.manager.request(encodedUrl!, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate()
            .responseJSON(completionHandler: { (response) -> Void in
                
                switch response.result {
                case .success:
                    print("Alamofire Automatic validation successful")
                    completion(response.result.value, nil, true)
                    
                case .failure(let error):
                    
                    print("Alamofire Automatic validation not successful!\nError: \(error.localizedDescription)")
                    if let data = response.data {
                        completion(nil, data, false)
                    }else{
                        completion(nil, nil, false)
                    }
                }
            })
    }
    
    func GET(url: String, completion: @escaping (_ json: Any?, _ errorData: Data?, _ success: Bool) -> ()) {
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        
        self.manager.request(encodedUrl!, method: HTTPMethod.get, encoding: JSONEncoding.default, headers: headers).validate().debugLog().responseJSON(completionHandler: { (response) -> Void in
            
                switch response.result {
                case .success:
                    print("Alamofire Automatic validation successful")
                    completion(response.result.value, nil, true)
                    
                case .failure(let error):
                    
                    print("Alamofire Automatic validation not successful!\nError: \(error)")
                    
                    
                    if let data = response.data {
                        completion(nil, data, false)
                    }else{
                        completion(nil, nil, false)
                    }
                }
            })
    }
    
    func PATCH(url: String, parameters: [String:Any]?=nil, completion: @escaping (_ json: Any?, _ errorData: Data?, _ success: Bool) -> ()) {
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        
        self.manager.request(encodedUrl!, method: HTTPMethod.patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate()
            .responseJSON(completionHandler: { (response) -> Void in
                
                switch response.result {
                case .success:
                    print("Alamofire Automatic validation successful")
                    completion(response.result.value, nil, true)
                    
                case .failure(let error):
                    
                    print("Alamofire Automatic validation not successful!\nError: \(error)")
                    
                    if let data = response.data {
                        completion(nil, data, false)
                    }else{
                        completion(nil, nil, false)
                    }
                }
            })
    }
    
    func DELETE(url: String, parameters: [String:Any]?=nil, completion: @escaping (_ json: Any?, _ errorData: Data?, _ success: Bool) -> ()) {
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        self.manager.request(encodedUrl!, method: HTTPMethod.delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate()
            .responseJSON(completionHandler: { (response) -> Void in
                
                switch response.result {
                case .success:
                    print("Alamofire Automatic validation successful for deletion")
                    completion(response.result.value, nil, true)
                    
                case .failure(let error):
                    
                    print("Alamofire Automatic validation not successful for deletion!\nError: \(error)")
                    
                    if let data = response.data {
                        completion(nil, data, false)
                    }else{
                        completion(nil, nil, false)
                    }
                }
            })
    }
    
    func DOWNLOAD(url:String, progCompletion: @escaping (_ progress: Double)->Void, completion: @escaping (_ fileName: URL?, _ success: Bool) -> Void) {
        
        clearDocumentsFolder()
        
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        
        self.manager.download(encodedUrl!, to: destination)
            .downloadProgress { progress in
                progCompletion(progress.fractionCompleted)
            }
            .responseData { (response) in
                
                switch response.result {
                case .success( _):
                    completion(response.destinationURL, true)
                case .failure:
                    completion(nil, false)
                }
                
        }
        
    }
    
    func clearDocumentsFolder(){
        
        // Get the document directory url
        let fileManager = FileManager.default
        let documentsUrl =  fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            
            for path in directoryContents {
                
                do {
                    try fileManager.removeItem(at: path)
                }catch let error as NSError {
                    print("Error: \(error.debugDescription)")
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
}

extension Request {
    public func debugLog() -> Self {
        debugPrint(self)
        return self
    }
}
