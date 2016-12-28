//
//  ContentLockerViewController.swift
//  Insecurity-Swift
//
//  Created by Alan Scarpa on 12/24/16.
//  Copyright © 2016 ARC. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ContentLockerViewController: UIViewController {

    @IBOutlet weak var nativeExpressAdView: GADNativeExpressAdView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        RootViewController.sharedInstance.showNavigationBar = true

        nativeExpressAdView.adUnitID = "ca-app-pub-5280387640092106/4400576078"
        nativeExpressAdView.rootViewController = self
        
        let request = GADRequest()
        //request.testDevices = [kGADSimulatorID]
        nativeExpressAdView.load(request)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        RootViewController.sharedInstance.showNavigationBar = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
