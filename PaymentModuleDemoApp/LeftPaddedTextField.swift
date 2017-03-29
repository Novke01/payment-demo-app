//
//  LeftPaddedTextField.swift
//  PaymentModuleDemoApp
//
//  Created by Marko Stajic on 3/29/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import UIKit

class LeftPaddedTextField: UITextField {

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 8, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 8, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }

}
