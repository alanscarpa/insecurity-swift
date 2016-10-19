//
//  LoginViewController.swift
//  Insecurity-Swift
//
//  Created by Alan Scarpa on 10/11/16.
//  Copyright © 2016 ARC. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var backgroundPatternImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    func setUpUI() {
        backgroundPatternImageView.backgroundColor = UIColor(patternImage: UIImage(named: "homeBg")!)
    }

    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            loginButtonTapped()
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
    
    @IBAction func loginButtonTapped() {
        // TODO: check if user exists on firebase,
        // then present home vc
        RootViewController.sharedInstance.pushHomeVC()
    }
    
    @IBAction func signupButtonTapped() {
        RootViewController.sharedInstance.pushSignupVC()
    }
}
