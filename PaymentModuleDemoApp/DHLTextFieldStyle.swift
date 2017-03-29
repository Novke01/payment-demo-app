//
//  DHLTextFieldStyle.swift
//  PaymentModuleDemoApp
//
//  Created by Marko Stajic on 3/29/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import UIKit

public class DHLTextFieldStyle {
    
    public var backgroundColor: UIColor
    public var cornerRadius: CGFloat
    public var styleName: String
    public var borderStyle: UITextBorderStyle
    
    public init(backgroundColor: UIColor, borderStyle: UITextBorderStyle, cornerRadius: CGFloat, styleName: String){
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.styleName = styleName
        self.borderStyle = borderStyle
    }
    
    public class func grayAndRounded() -> DHLTextFieldStyle {
        return DHLTextFieldStyle(backgroundColor: UIColor.dhlBlackTransparent, borderStyle: UITextBorderStyle.none, cornerRadius: 10.0, styleName: "grayAndRounded")
    }
}

