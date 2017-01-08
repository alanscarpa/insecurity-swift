//
//  HomeViewController.swift
//  Insecurity-Swift
//
//  Created by Alan Scarpa on 10/11/16.
//  Copyright © 2016 ARC. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseAuth
import FirebaseDatabase

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
        let userID = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference()
        
        ref.child("users").child(userID ?? "").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let isConverted = value?["converted"] as? Bool ?? false
            if isConverted || !UserDefaultsManager.shared.hasTakenFirstPhoto {
                self?.launchTrapVC()
            } else {
                self?.launchContentLocker()
            }
        }) { [weak self] error in
            self?.present(UIAlertController.createSimpleAlert(withTitle: "Error", message: error.localizedDescription), animated: true, completion: nil)
        }
    }
    
    func launchTrapVC() {
        AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == .authorized ? pushTrapVC() : askForCameraPermission()
    }
    
    func launchContentLocker() {
        RootViewController.sharedInstance.pushContentLockerVC()
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
        RootViewController.sharedInstance.pushSnoopersVC()
    }
    
    @IBAction func howItWorksButtonTapped() {
        RootViewController.sharedInstance.pushHowItWorksVC()
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
