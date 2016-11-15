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
    
    private let rootNavigationController = UINavigationController()
    var showNavigationBar = false {
        didSet {
            rootNavigationController.setNavigationBarHidden(!showNavigationBar, animated: true)
        }
    }
    
    var showToolBar = false {
        didSet {
            rootNavigationController.setToolbarHidden(!showToolBar, animated: true)
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
    
    func addBottomToolBarItems(shareButton: UIBarButtonItem, deleteButton: UIBarButtonItem) {
        setToolbarItems([shareButton, deleteButton], animated: true)
    }
    
    func popViewController() {
        rootNavigationController.popViewController(animated: true)
    }
    
    func goToLoginVC() {
        rootNavigationController.setViewControllers([LoginViewController()], animated: true)
    }
    
    func pushHomeVC() {
        rootNavigationController.pushViewController(HomeViewController(), animated: true)
    }
    
    func goToHomeVC() {
        rootNavigationController.setViewControllers([HomeViewController()], animated: true)
    }

    func pushSignupVC() {
        rootNavigationController.pushViewController(SignupViewController(), animated: true)
    }
    
    func pushHowItWorksVC() {
        rootNavigationController.pushViewController(HowItWorksViewController(), animated: true)
    }
    
    func pushTrapVC() {
        rootNavigationController.pushViewController(TrapViewController(), animated: true)
    }
    
    func pushSnoopersVC() {
        rootNavigationController.pushViewController(SnoopersViewController(), animated: true)
    }
    
    func pushPhotoVCWithImageData(imageData: FBImageData) {
        let photoVC = PhotoViewController()
        photoVC.configureWithImageData(imageData: imageData)
        rootNavigationController.pushViewController(photoVC, animated: true)
    }
}
