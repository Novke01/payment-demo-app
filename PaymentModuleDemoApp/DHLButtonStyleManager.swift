//
//  DHLButtonStyleManager.swift
//  PaymentModuleDemoApp
//
//  Created by Marko Stajic on 3/29/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import Foundation

public class DHLButtonStyleManager {
    
    public static let styles = [
        "redAndRounded": DHLButtonStyle.redAndRounded(),
        "redAndClear": DHLButtonStyle.redAndClear()
    ]
    
    public class func style(name: String) -> DHLButtonStyle? {
        guard let dStyle = styles[name] else {
            return nil //Will return Storyboard defined font instead
        }
        return dStyle
    }
}
