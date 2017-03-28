//
//  DHLFontManager.swift
//  PaymentModuleDemoApp
//
//  Created by Marko Stajic on 3/27/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import Foundation
import UIKit

public class DHLFontManager {
    
    public static let fonts = [
        "textRegularBlack": DHLFont.textRegularBlack(),
    ]
    
    public class func font(name: String) -> DHLFont? {
        guard let dFont = fonts[name] else {
            return nil //Will return Storyboard defined font instead
        }
        return dFont
    }
}

