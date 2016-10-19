//
//  SignupViewController.swift
//  Insecurity-Swift
//
//  Created by Alan Scarpa on 10/19/16.
//  Copyright © 2016 ARC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignupViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RootViewController.sharedInstance.showNavigationBar = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        RootViewController.sharedInstance.showNavigationBar = false
    }

    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            signUpButtonTapped()
        }
        return false
    }
    
    // MARK: - UIResponder
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch = event?.allTouches?.first
        if touch?.view?.isKind(of: UITextField.self) == false {
            view.endEditing(true)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func signUpButtonTapped() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                // TODO: show alert
                print(error)
                print(error.localizedDescription)
            } else {
                print(user)
                // TODO: login
            }
        }
    }
    
    @IBAction func privacyPolicyButtonTapped() {
        // TODO: reupload to skytopdesigns
        if let url = URL(string: "http://www.skytopdesigns.com/insecurity/privacypolicy") {
            UIApplication.shared.openURL(url)
        }
    }
    
}
