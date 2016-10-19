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
    
    private func validEmailAndPassword() -> (email: String, password: String)? {
        if let email = emailTextField.text,
            let password = passwordTextField.text, password.characters.count >= 6, passwordTextField.text == confirmPasswordTextField.text {
            return (email, password)
        }
        return nil
    }
    
    // MARK: - Actions
    
    @IBAction func signUpButtonTapped() {
        guard let credentials = validEmailAndPassword() else {
            present(UIAlertController.createSimpleAlert(withTitle: "Error", message: "Make sure your email is valid, your password has at least 6 characters, and both passwords match."), animated: true, completion: nil)
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: credentials.email, password: credentials.password) { (user, error) in
            if let error = error {
                self.present(UIAlertController.createSimpleAlert(withTitle: "Error", message: error.localizedDescription), animated: true, completion: nil)
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
