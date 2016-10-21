//
//  TrapViewController.swift
//  Insecurity-Swift
//
//  Created by Alan Scarpa on 10/19/16.
//  Copyright © 2016 ARC. All rights reserved.
//

import UIKit
import AVFoundation

class TrapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var pictureIsBeingTaken = false
    var isTrapSet = false
    let imagePickerController = UIImagePickerController()
    var bustedPhoto = UIImage()
    var pictureFrameImageView = UIImageView()
    let audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "siren", ofType: "mp3")!))
    
    @IBOutlet weak var trapIsSetLabel: UILabel!
    @IBOutlet weak var lockPhoneLabel: UILabel!
    @IBOutlet weak var bestResultsLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var snoopingLabel: UILabel!
    @IBOutlet weak var trustMeLabel: UILabel!
    @IBOutlet weak var sayCheeseLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpImagePickerController()
        setUpAudioPlayer()
        registerForNotifications()
        
//        PFUser *currentUser = [PFUser currentUser];
//        self.parseUserId = currentUser.objectId;
    }
    
    deinit {
        unregisterForNotifications()
    }
    
    // MARK: - Setup
    
    private func setUpImagePickerController() {
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        imagePickerController.modalPresentationStyle = .currentContext
        imagePickerController.showsCameraControls = false
        imagePickerController.cameraDevice = .front
    }
    
    private func setUpAudioPlayer() {
        audioPlayer.prepareToPlay()
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            present(UIAlertController.createSimpleAlert(withTitle: "Sound Error", message: error.localizedDescription), animated: true, completion: nil)
        }
    }
    
    // MARK: - Notifications
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(takePhoto), name: .UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(phoneDidLock), name: .UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cameraIsReady), name: .AVCaptureSessionDidStartRunning, object: nil)
    }
    
    private func unregisterForNotifications() {
        [.UIApplicationDidBecomeActive, .UIApplicationWillResignActive, .AVCaptureSessionDidStartRunning].forEach({ NotificationCenter.default.removeObserver(self, name: $0, object: nil) })
    }
    
    func takePhoto() {
        
    }
    
    func phoneDidLock() {
        
    }
    
    func cameraIsReady() {
        // todo: dont think is needed
    }
    
    // MARK: - Actions

    @IBAction func cancelButtonTapped() {
        RootViewController.sharedInstance.popViewController()
    }
    
}
