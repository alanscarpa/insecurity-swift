//
//  HomeViewController.swift
//  Insecurity-Swift
//
//  Created by Alan Scarpa on 10/11/16.
//  Copyright © 2016 ARC. All rights reserved.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController, FirebaseManagerDelegate {

    @IBOutlet weak var backgroundPatternImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseManager.sharedInstance.delegate = self
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RootViewController.sharedInstance.showNavigationBar = false
        FirebaseManager.sharedInstance.listenForAuthStateChanges()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FirebaseManager.sharedInstance.stopListeningForAuthStateChanges()
    }
    
    private func setUpUI() {
        backgroundPatternImageView.backgroundColor = UIColor(patternImage: UIImage(named: "homeBg")!)
    }

    @IBAction func setTrapButtonTapped() {
        AVCaptureDevice.authorizationStatus(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video))) == .authorized ? pushTrapVC() : askForCameraPermission()
    }
    
    private func askForCameraPermission() {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video))) ==  .denied
            || AVCaptureDevice.authorizationStatus(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video))) ==  .restricted {
            presentCameraPermissionsAlert()
        } else {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                OperationQueue.main.addOperation { [weak self] in
                    granted ? self?.pushTrapVC() : self?.presentCameraPermissionsAlert()
                }
            }
        }
    }
    
    private func presentCameraPermissionsAlert() {
        present(UIAlertController.createSimpleAlert(withTitle: "Error", message: "You must give Insecurity camera permission in order to take photos of phone snoopers.  Please go to your Settings and enable Camera permission."), animated: true, completion: nil)
    }
    
    private func pushTrapVC() {
        RootViewController.sharedInstance.pushTrapVC()
    }
    
    @IBAction func viewSnoopersButtonTapped() {
        RootViewController.sharedInstance.pushSnoopersVC()
    }
    
    @IBAction func howItWorksButtonTapped() {
        RootViewController.sharedInstance.pushHowItWorksVC()
    }
    
    @IBAction func freeOfferButtonTapped() {
        if let url = URL(string: "http://linkz.it/s/54n/") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:])
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func logoutButtonTapped() {
        FirebaseManager.sharedInstance.signOutCurrentUser { [weak self] result in
            if let error = result.error {
                self?.present(UIAlertController.createSimpleAlert(withTitle: "Error Logging Out", message: error.localizedDescription), animated: true, completion: nil)
            }
            ImageLoader.sharedInstance.clearImages()
        }
    }
    
    // MARK: - FirebaseManagerDelegate
    
    func currentUserDidSignOut() {
        RootViewController.sharedInstance.popViewController()
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVMediaType(_ input: AVMediaType) -> String {
	return input.rawValue
}
