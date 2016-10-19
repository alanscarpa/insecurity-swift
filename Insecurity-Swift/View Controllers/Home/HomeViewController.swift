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

class HomeViewController: UIViewController {

    @IBOutlet weak var backgroundPatternImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if auth.currentUser == nil {
                RootViewController.sharedInstance.popViewController()
            }
        })
    }
    
    func setUpUI() {
        backgroundPatternImageView.backgroundColor = UIColor(patternImage: UIImage(named: "homeBg")!)
    }

    @IBAction func setTrapButtonTapped() {
        
    }
    
    @IBAction func viewSnoopersButtonTapped() {
        
    }
    
    @IBAction func logoutButtonTapped() {
        try! FIRAuth.auth()?.signOut()
    }
    
    @IBAction func howItWorksButtonTapped() {

    }
    
}
