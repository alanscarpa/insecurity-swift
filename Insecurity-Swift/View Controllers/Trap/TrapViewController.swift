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
    let audioSession = AVAudioSession.sharedInstance()
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
        imagePickerController.cameraFlashMode = .on
    }
    
    private func setUpAudioPlayer() {
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "siren", ofType: "mp3")!))
            audioPlayer.prepareToPlay()
        } catch {
            present(UIAlertController.createSimpleAlert(withTitle: "Sound Error", message: error.localizedDescription), animated: true, completion: nil)
        }
    }
    
    // MARK: - Notifications
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(takePhoto), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(phoneWillLock), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    private func unregisterForNotifications() {
        [UIApplication.didBecomeActiveNotification, UIApplication.willResignActiveNotification].forEach({ NotificationCenter.default.removeObserver(self, name: $0, object: nil) })
    }
    
    @objc func phoneWillLock() {
        [trapIsSetLabel, lockPhoneLabel, cancelButton].forEach({ $0.isHidden = true })
        [snoopingLabel, trustMeLabel, sayCheeseLabel].forEach({ $0.isHidden = false })
    }
    
    @objc func takePhoto() {
        guard FirebaseManager.sharedInstance.currentUserIsSignedIn else { return }
        guard self.isViewLoaded && self.view.window != nil else { return }
        guard UIApplication.shared.applicationState == .active else { return }
        present(imagePickerController, animated: true) { [weak self] in
            guard UIApplication.shared.applicationState == .active else {
                self?.imagePickerController.dismiss(animated: false, completion: nil)
                return
            }
            self?.imagePickerController.takePicture()
            self?.audioPlayer.play()
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        guard let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage else {
            completeTrapPhotoProcess()
            return
        }
        guard let photoData = image.jpegData(compressionQuality: 0.3) else {
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
