//
//  DHLFont.swift
//  PaymentModuleDemoApp
//
//  Created by Marko Stajic on 3/27/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import UIKit

public class DHLFont {
    
    public var font: UIFont
    public var color: UIColor
    public var fontName: String
    
    public init(font: UIFont, color: UIColor, fontName: String) {
        self.font = font
        self.color = color
        self.fontName = fontName
    }
    
    // Label
    
    public class func textRegularBlack() -> DHLFont {
        return DHLFont(font: UIFont.dhlRegular(), color: UIColor.black, fontName: "textRegularBlack")
    }
}

