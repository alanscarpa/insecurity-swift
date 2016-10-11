//
//  RootViewController.swift
//  Insecurity-Swift
//
//  Created by Alan Scarpa on 10/11/16.
//  Copyright © 2016 ARC. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UINavigationControllerDelegate {

    let rootNavigationController = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        rootNavigationController.delegate = self
        rootNavigationController.willMove(toParentViewController: self)
        

//        [self addChildViewController:self.rootNavigationController];
//        [self.view addSubview:self.rootNavigationController.view];
//        [self.rootNavigationController didMoveToParentViewController:self];
//        [self.rootNavigationController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        presentLoginScreen()
    }
    
    func presentLoginScreen() {
        navigationController?.viewControllers = [LoginViewController()]
    }

}
