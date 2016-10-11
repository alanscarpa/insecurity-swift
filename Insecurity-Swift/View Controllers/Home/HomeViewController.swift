//
//  HomeViewController.swift
//  Insecurity-Swift
//
//  Created by Alan Scarpa on 10/11/16.
//  Copyright © 2016 ARC. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var backgroundPatternImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func setUpUI() {
        backgroundPatternImageView.backgroundColor = UIColor(patternImage: UIImage(named: "homeBg")!)
    }

}
