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
    var showNavigationBar = false {
        didSet {
            rootNavigationController.setNavigationBarHidden(!showNavigationBar, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        rootNavigationController.setNavigationBarHidden(true, animated: false)
        rootNavigationController.delegate = self
        rootNavigationController.willMove(toParentViewController: self)
        addChildViewController(rootNavigationController)
        view.addSubview(rootNavigationController.view)
        rootNavigationController.didMove(toParentViewController: self)
        
        // TODO: import purelayout instead of doing this, maybe
        rootNavigationController.view.frame = super.view.frame
    }
    
    func presentLoginVC() {
        // TODO: make sure to log out user every time
        // Maybe log out when app goes to background (as long as it isnt called on lock screen)
        rootNavigationController.viewControllers = [LoginViewController()]
    }
    
    func presentHomeVC() {
        rootNavigationController.pushViewController(HomeViewController(), animated: true)
    }

    func presentSingupVC() {
        rootNavigationController.pushViewController(SignupViewController(), animated: true)
    }
}
