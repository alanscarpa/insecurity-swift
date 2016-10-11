//
//  RootViewController.swift
//  Insecurity-Swift
//
//  Created by Alan Scarpa on 10/11/16.
//  Copyright © 2016 ARC. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UINavigationControllerDelegate {

    static let sharedInstance = RootViewController()
    
    let rootNavigationController = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        rootNavigationController.setNavigationBarHidden(true, animated: false)
        rootNavigationController.delegate = self
        rootNavigationController.willMove(toParentViewController: self)
        addChildViewController(rootNavigationController)
        view.addSubview(rootNavigationController.view)
        rootNavigationController.didMove(toParentViewController: self)
        
        // TODO: import purelayout instead of doing this
        rootNavigationController.view.frame = super.view.frame
//        [self.rootNavigationController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        presentLoginScreen()
    }
    
    func presentLoginScreen() {
        rootNavigationController.viewControllers = [LoginViewController()]
    }

}
