//
//  ContentLockerViewController.swift
//  Insecurity-Swift
//
//  Created by Alan Scarpa on 12/24/16.
//  Copyright © 2016 ARC. All rights reserved.
//

import UIKit
import SVProgressHUD

class ContentLockerViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RootViewController.sharedInstance.showNavigationBar = true
        SVProgressHUD.show(withStatus: "Loading...")

        webView.delegate = self
        // TODO: change from testuser to real user AND obviously must be after log in
        let userID = "testuser"
        let request = URLRequest(url: URL(string: "http://letsfuzz.com/insecurity_upgrade/og.php?tool=cl&id=4a24fbfcdf1f8c4c5c28b1386faf034c&aff_sub=\(userID)")!)
        webView.loadRequest(request)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        RootViewController.sharedInstance.showNavigationBar = false
        SVProgressHUD.dismiss()
    }
    
    // MARK: - UIWebViewDelegate
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }

}
