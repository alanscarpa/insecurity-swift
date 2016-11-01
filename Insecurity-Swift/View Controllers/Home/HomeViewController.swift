//
//  HomeViewController.swift
//  Insecurity-Swift
//
//  Created by Alan Scarpa on 10/11/16.
//  Copyright © 2016 ARC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import AVFoundation

class HomeViewController: UIViewController {

    @IBOutlet weak var backgroundPatternImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FirebaseManager.sharedInstance.listenForAuthStateChangesWithHandler(authStateChangedHandler)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FirebaseManager.sharedInstance.stopListeningForAuthStateChanges()
    }
    
    private func setUpUI() {
        backgroundPatternImageView.backgroundColor = UIColor(patternImage: UIImage(named: "homeBg")!)
    }

    @IBAction func setTrapButtonTapped() {
        AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == .authorized ? pushTrapVC() : askForCameraPermission()
    }
    
    private func askForCameraPermission() {
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) ==  .denied
            || AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) ==  .restricted {
            presentCameraPermissionsAlert()
        } else {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { granted in
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
        
    }
    
    @IBAction func howItWorksButtonTapped() {
        RootViewController.sharedInstance.pushHowItWorksVC()
    }
    
    @IBAction func logoutButtonTapped() {
        FirebaseManager.sharedInstance.signOutCurrentUser { [weak self] result in
            if let error = result.error {
                self?.present(UIAlertController.createSimpleAlert(withTitle: "Error Logging Out", message: error.localizedDescription), animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Firebase Auth State Handler
    
    private func authStateChangedHandler(auth: FIRAuth, user: FIRUser?) -> Swift.Void {
        if FirebaseManager.sharedInstance.currentUserIsSignedOut {
            RootViewController.sharedInstance.popViewController()
        }
    }
    
}
