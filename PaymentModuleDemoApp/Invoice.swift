//
//  Invoice.swift
//  PaymentModuleDemoApp
//
//  Created by Marko Stajic on 3/23/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import UIKit

class Invoice: NSObject, NSCopying {
    var qrCodeRevision : String = ""
    var merchantName : String = ""
    var merchantAddress : String = ""
    var merchantCity : String = ""
    var merchantExtra1 : String?
    var merchantExtra2 : String?
    var buyerName : String?
    var buyerAddress : String?
    var buyerCity : String?
    var buyerExtra1 : String?
    var paymentDescription : String = ""
    var price : Double = 0.0
    var priceIsEditable: Bool = false
    var currency: String = ""
    var transactionId: String = ""
    var colorScheme: String = ""
    var extra1 : String?
    var extra2 : String?
    var extra3 : String?
    var extra4 : String?
    
    override init() {
        super.init()
    }
    
    init(qrCodeRevision: String,
        merchantName : String,
        merchantAddress: String,
        merchantCity : String,
        merchantExtra1 : String?,
        merchantExtra2 : String?,
        buyerName : String?,
        buyerAddress : String?,
        buyerCity : String?,
        buyerExtra1 : String?,
        paymentDescription : String,
        price : Double,
        priceIsEditable: Bool,
        currency: String,
        transactionId: String,
        colorScheme: String,
        extra1 : String?,
        extra2 : String?,
        extra3 : String?,
        extra4 : String?) {
        
        self.qrCodeRevision = qrCodeRevision
        self.merchantName = merchantName
        self.merchantAddress = merchantAddress
        self.merchantCity = merchantCity
        self.merchantExtra1 = merchantExtra1
        self.merchantExtra2 = merchantExtra2
        self.buyerName = buyerName
        self.buyerAddress = buyerAddress
        self.buyerCity = buyerCity
        self.buyerExtra1 = buyerExtra1
        self.paymentDescription = paymentDescription
        self.price = price
        self.priceIsEditable = priceIsEditable
        self.currency = currency
        self.transactionId = transactionId
        self.colorScheme = colorScheme
        self.extra1 = extra1
        self.extra2 = extra2
        self.extra3 = extra3
        self.extra4 = extra4
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = Invoice(qrCodeRevision: qrCodeRevision, merchantName: merchantName, merchantAddress: merchantAddress, merchantCity: merchantCity, merchantExtra1: merchantExtra1, merchantExtra2: merchantExtra2, buyerName: buyerName, buyerAddress: buyerAddress, buyerCity: buyerCity, buyerExtra1: buyerExtra1, paymentDescription: paymentDescription, price: price, priceIsEditable: priceIsEditable, currency: currency, transactionId: transactionId, colorScheme: colorScheme, extra1: extra1, extra2: extra2, extra3: extra3, extra4: extra4)
        return copy
    }
    
    override var description: String {
        return "qrCodeRevision: \(qrCodeRevision), \nmerchantName: \(merchantName), \nmerchantAddress: \(merchantAddress), \nmerchantCity: \(merchantCity), \nmerchantExtra1: \(String(describing: merchantExtra1)), \nmerchantExtra2: \(String(describing: merchantExtra2)), \nbuyerName: \(String(describing: buyerName)), \nbuyerAddress: \(String(describing: buyerAddress)), \nbuyerCity: \(String(describing: buyerCity)), \nbuyerExtra1: \(String(describing: buyerExtra1)), \npaymentDescription: \(paymentDescription), \nprice: \(price), \npriceIsEditable: \(priceIsEditable), \ncurrency: \(currency), \ntransactionId: \(transactionId), \ncolorScheme: \(colorScheme), \nextra1: \(String(describing: extra1)), \nextra2: \(String(describing: extra2)), \nextra3: \(String(describing: extra3)), \nextra4: \(String(describing: extra4)))"
    }
    
    init(qrCodeString: String, separationCharacter: CharacterSet) {
        super.init()
        let stringComponents = qrCodeString.components(separatedBy: separationCharacter)
        
        self.qrCodeRevision = stringComponents[0]
        self.merchantName = stringComponents[1]
        self.merchantAddress = stringComponents[2]
        self.merchantCity = stringComponents[3]
        self.merchantExtra1 = stringComponents[4].checkIfExist()
        self.merchantExtra2 = stringComponents[5].checkIfExist()
        self.buyerName = stringComponents[6].checkIfExist()
        self.buyerAddress = stringComponents[7].checkIfExist()
        self.buyerCity = stringComponents[8].checkIfExist()
        self.buyerExtra1 = stringComponents[9].checkIfExist()
        self.paymentDescription = stringComponents[10]
        self.price = Double(stringComponents[11]) ?? 0.0
        self.priceIsEditable = stringComponents[12].returnBool()
        self.currency = stringComponents[13]
        self.transactionId = stringComponents[14]
        self.colorScheme = stringComponents[15]
        self.extra1 = stringComponents[16].checkIfExist()
        self.extra2 = stringComponents[17].checkIfExist()
        self.extra3 = stringComponents[18].checkIfExist()
        self.extra4 = stringComponents[19].checkIfExist()
        
    }
}
extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

extension String {
    func returnBool()->Bool{
        switch self {
        case "N":
            return false
        case "Y":
            return true
        default:
            return false
        }
    }
    func checkIfExist()->String?{
        if self != "" {
            return self
        }else{
            return nil
        }
    }
}
