//
//  HowItWorksViewController.swift
//  Insecurity-Swift
//
//  Created by Alan Scarpa on 10/19/16.
//  Copyright © 2016 ARC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class HowItWorksViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        RootViewController.sharedInstance.showNavigationBar = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        RootViewController.sharedInstance.showNavigationBar = false
    }

    @IBAction func privacyPolicyButtonTapped() {
        if let url = URL(string: "http://www.skytopdesigns.com/insecurity/privacypolicy") {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func deleteAccountButtonTapped() {
        let confirmationAlert = UIAlertController(title: "Are you sure?", message: "Are you sure you want to delete your account?  All your photos will be deleted.", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Yes, delete my account", style: .destructive) { action in
            FIRAuth.auth()?.currentUser?.delete(completion: { error in
                if let error = error {
                    self.present(UIAlertController.createSimpleAlert(withTitle: "Error", message: error.localizedDescription), animated: true, completion: nil)
                } else {
                    RootViewController.sharedInstance.goToLoginVC()
                }
            })
        }
        confirmationAlert.addAction(okAction)
        confirmationAlert.addAction(cancelAction)
        present(confirmationAlert, animated: true, completion: nil)
    }
    
}
