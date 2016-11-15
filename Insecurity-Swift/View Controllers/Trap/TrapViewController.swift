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
    
    let imagePickerController = UIImagePickerController()
    var bustedPhoto = UIImage()
    var pictureFrameImageView = UIImageView()
    var audioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var trapIsSetLabel: UILabel!
    @IBOutlet weak var lockPhoneLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var snoopingLabel: UILabel!
    @IBOutlet weak var trustMeLabel: UILabel!
    @IBOutlet weak var sayCheeseLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpImagePickerController()
        setUpAudioPlayer()
        registerForNotifications()
    }
    
    deinit {
        unregisterForNotifications()
    }
    
    // MARK: - Setup
    
    private func setUpImagePickerController() {
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        imagePickerController.modalPresentationStyle = .fullScreen
        imagePickerController.showsCameraControls = false
        imagePickerController.cameraDevice = .front
    }
    
    private func setUpAudioPlayer() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "siren", ofType: "mp3")!))
        } catch {
            present(UIAlertController.createSimpleAlert(withTitle: "Sound Error", message: error.localizedDescription), animated: true, completion: nil)
        }
        audioPlayer.prepareToPlay()
    }
    
    // MARK: - Notifications
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(takePhoto), name: .UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(phoneWillLock), name: .UIApplicationWillResignActive, object: nil)
    }
    
    private func unregisterForNotifications() {
        [.UIApplicationDidBecomeActive, .UIApplicationWillResignActive].forEach({ NotificationCenter.default.removeObserver(self, name: $0, object: nil) })
    }
    
    func phoneWillLock() {
        [trapIsSetLabel, lockPhoneLabel, cancelButton].forEach({ $0.isHidden = true })
        [snoopingLabel, trustMeLabel, sayCheeseLabel].forEach({ $0.isHidden = false })
    }
    
    func takePhoto() {
        guard FirebaseManager.sharedInstance.currentUserIsSignedIn else { return }
        guard self.isViewLoaded && self.view.window != nil else { return }
        guard UIApplication.shared.applicationState == .active else { return }
        present(imagePickerController, animated: true) { [weak self] in
            guard let strongSelf = self else { self?.completeTrapPhotoProcess(); return }
            guard UIApplication.shared.applicationState == .active else { self?.completeTrapPhotoProcess(); return }
            strongSelf.imagePickerController.takePicture()
            strongSelf.audioPlayer.play()
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { completeTrapPhotoProcess()
            return
        }
        guard let photoData = UIImageJPEGRepresentation(image, 0.3) else {
            completeTrapPhotoProcess()
            return
        }
        
        FirebaseManager.sharedInstance.put(photoData: photoData) { [weak self] result in
            if let error = result.error {
               self?.present(UIAlertController.createSimpleAlert(withTitle: "Error", message: error.localizedDescription), animated: true, completion: nil) 
            }
            self?.completeTrapPhotoProcess()
        }
    }
    
    func completeTrapPhotoProcess() {
        FirebaseManager.sharedInstance.signOutCurrentUser { [weak self] result in
            if let error = result.error {
                self?.present(UIAlertController.createSimpleAlert(withTitle: "Error", message: error.localizedDescription), animated: true, completion: nil)
            }
            self?.imagePickerController.dismiss(animated: false) {
                RootViewController.sharedInstance.goToLoginVC()
            }
        }
    }
    
    // MARK: - Actions

    @IBAction func cancelButtonTapped() {
        RootViewController.sharedInstance.popViewController()
    }
    
}
