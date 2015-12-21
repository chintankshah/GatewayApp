//
//  LeftPaddingLabel.swift
//  GatewayApp
//
//  Created by Shah, Chintan on 12/21/15.
//  Copyright © 2015 Shah, Chintan. All rights reserved.
//

import UIKit

class LeftPaddingLabel: UILabel {
    
    override func drawRect(rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
}