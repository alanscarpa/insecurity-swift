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
        // http://letsfuzz.com/insecurity_upgraded.html
        // http://letsfuzz.com/insecurity_upgrade/og.php?tool=cl&id=4a24fbfcdf1f8c4c5c28b1386faf034c&aff_sub=\(userID)
        // https://www.appcaptcha.com/cl.php?id=4a24fbfcdf1f8c4c5c28b1386faf034c&aff_sub4=\(userID)
        
        // http://lockwall.xyz/wall/2Cn/\(userID)
        
        //http://jump.ogtrk.net/aff_c?aff_id=69224&offer_id=1930
        print(Locale.current.regionCode!)
        let request = URLRequest(url: URL(string: "http://letsfuzz.com/insecurity_upgraded.html?userID=\(userID)")!)
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
    
//    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
//        if navigationType == .linkClicked {
//            print(request.url!)
//            UIApplication.shared.openURL(request.url!)
//            return false
//        }
//        return true
//    }

}
