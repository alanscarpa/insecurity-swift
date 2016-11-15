//
//  UIAlertController+Insecurity.swift
//  Insecurity-Swift
//
//  Created by Alan Scarpa on 10/19/16.
//  Copyright © 2016 ARC. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func createSimpleAlert(withTitle title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(action)
        return alertController
    }
    
    static func createDeleteAlert(withTitle title: String, message: String, handler: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let action = UIAlertAction(title: "Delete", style: .destructive, handler: handler)
        alertController.addAction(cancel)
        alertController.addAction(action)
        return alertController
    }
}
