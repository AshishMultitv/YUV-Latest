//
//  LeftPaddedTextField.swift
//  Dollywood Play
//
//  Created by Cybermac002 on 28/08/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit

class LeftPaddedTextField: UITextField {

    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
