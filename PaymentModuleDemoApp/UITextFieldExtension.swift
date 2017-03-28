//
//  IUTextFieldExtension.swift
//  PaymentModuleDemoApp
//
//  Created by Marko Stajic on 3/27/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import UIKit
import Foundation

private var dhlFontAssociationKey: UInt8 = 0

@IBDesignable extension UITextField {
    
    @IBInspectable var dhlFont: String? {
        get {
            return objc_getAssociatedObject(self, &dhlFontAssociationKey) as? String
        }
        
        set {
            guard let dhlFontName = newValue else { return }
            objc_setAssociatedObject(self, &dhlFontAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            guard let dhlFont = DHLFontManager.font(name: dhlFontName) else { return }
            self.font = dhlFont.font
            self.textColor = dhlFont.color
            self.backgroundColor = UIColor.dhlBlackTransparent
            self.layer.cornerRadius = 10.0
        }
    }
}

extension UITextField {
    func setDoneToolbar(){
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let toolbarRightButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(resignFirstResponder))
        toolbarRightButton.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 17.0)], for: UIControlState.normal)
        toolbar.barTintColor = UIColor.orange
        toolbar.isTranslucent = false
        
        toolbarRightButton.tintColor = UIColor.white
        toolbar.items = [flexibleSpace, toolbarRightButton]
        inputAccessoryView = toolbar
    }
}



