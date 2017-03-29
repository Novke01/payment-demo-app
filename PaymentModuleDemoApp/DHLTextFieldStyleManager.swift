//
//  DHLTextFieldStyleManager.swift
//  PaymentModuleDemoApp
//
//  Created by Marko Stajic on 3/29/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import UIKit


public class DHLTextFieldStyleManager {
    
    public static let styles = [
        "grayAndRounded": DHLTextFieldStyle.grayAndRounded()
    ]
    
    public class func style(name: String) -> DHLTextFieldStyle? {
        guard let dStyle = styles[name] else {
            return nil //Will return Storyboard defined font instead
        }
        return dStyle
    }
}
