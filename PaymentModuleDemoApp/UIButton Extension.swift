//
//  UIButton Extension.swift
//  PaymentModuleDemoApp
//
//  Created by Marko Stajic on 3/29/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import UIKit

private var dhlFontAssociationKey: UInt8 = 0

@IBDesignable extension UIButton {
    
    @IBInspectable var dhlButtonStyle: String? {
        get {
            return objc_getAssociatedObject(self, &dhlFontAssociationKey) as? String
        }
        
        set {
            guard let dhlButtonStyleName = newValue else { return }
            objc_setAssociatedObject(self, &dhlFontAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            guard let dhlStyle = DHLButtonStyleManager.style(name: dhlButtonStyleName) else { return }
            self.setTitleColor(dhlStyle.titleColor, for: UIControlState.normal)
            self.backgroundColor = dhlStyle.backgroundColor
            self.layer.cornerRadius = dhlStyle.cornerRadius
        }
    }
}

