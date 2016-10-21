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
        FIRAuth.auth()?.addStateDidChangeListener(authStateChangedHandler)
    }
    
    private func setUpUI() {
        backgroundPatternImageView.backgroundColor = UIColor(patternImage: UIImage(named: "homeBg")!)
    }

    @IBAction func setTrapButtonTapped() {
        // TODO: clean up
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) ==  .authorized {
            RootViewController.sharedInstance.pushTrapVC()
        } else if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) ==  .denied || AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) ==  .restricted {
            self.present(UIAlertController.createSimpleAlert(withTitle: "Error", message: "You must give Insecurity camera permission in order to take photos of phone snoopers.  Please go to your Settings and enable Camera permission."), animated: true, completion: nil)
        } else {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { granted in
                OperationQueue.main.addOperation {
                    if granted {
                        RootViewController.sharedInstance.pushTrapVC()
                    } else {
                        self.present(UIAlertController.createSimpleAlert(withTitle: "Error", message: "You must give Insecurity camera permission in order to take photos of phone snoopers.  Please go to your Settings and enable Camera permission."), animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func viewSnoopersButtonTapped() {
        
    }
    
    @IBAction func howItWorksButtonTapped() {
        RootViewController.sharedInstance.pushHowItWorksVC()
    }
    
    @IBAction func logoutButtonTapped() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch {
            present(UIAlertController.createSimpleAlert(withTitle: "Error Logging Out", message: error.localizedDescription), animated: true, completion: nil)
        }
    }
    
    // MARK: - Helpers
    
    private func authStateChangedHandler(auth: FIRAuth, user: FIRUser?) -> Swift.Void {
        if auth.currentUser == nil {
            RootViewController.sharedInstance.popViewController()
        }
    }
    
}
