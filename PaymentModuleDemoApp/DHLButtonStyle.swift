//
//  DHLButtonStyle.swift
//  PaymentModuleDemoApp
//
//  Created by Marko Stajic on 3/29/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import UIKit

public class DHLButtonStyle {
    
    public var titleColor: UIColor
    public var cornerRadius: CGFloat
    public var styleName: String
    public var backgroundColor: UIColor
    
    public init(backgroundColor: UIColor, titleColor: UIColor, cornerRadius: CGFloat=0, styleName: String){
        self.backgroundColor = backgroundColor
        self.titleColor = titleColor
        self.cornerRadius = cornerRadius
        self.styleName = styleName
    }
    
    public class func redAndRounded() -> DHLButtonStyle {
        return DHLButtonStyle(backgroundColor: UIColor.dhlRed, titleColor: UIColor.white, cornerRadius: 10.0, styleName: "redAndRounded")
    }
    
    public class func redAndClear() -> DHLButtonStyle {
        return DHLButtonStyle(backgroundColor: UIColor.clear, titleColor: UIColor.dhlRed, styleName: "redAndClear")
    }
}

