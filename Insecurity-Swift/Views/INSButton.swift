//
//  INSButton.swift
//  Insecurity-Swift
//
//  Created by Alan Scarpa on 11/16/16.
//  Copyright © 2016 ARC. All rights reserved.
//

import UIKit

class INSButton: UIButton {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.borderWidth = 5
        layer.borderColor = UIColor.insButtonBorderBlue.cgColor
        layer.cornerRadius = 10
        clipsToBounds = true
    }

}
