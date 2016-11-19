//
//  PhotoViewController.swift
//  Insecurity-Swift
//
//  Created by Alan Scarpa on 11/13/16.
//  Copyright © 2016 ARC. All rights reserved.
//

import UIKit
import SVProgressHUD

class PhotoViewController: UIViewController {

    private var imageData = FBImageData()
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photo"
        photoImageView.image = imageData.image
        setUpNavigationController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        RootViewController.sharedInstance.showToolBar = false
    }
    
    private func setUpNavigationController() {
        RootViewController.sharedInstance.showToolBar = true
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        setToolbarItems([shareButton, spacer, deleteButton], animated: true)
    }

    func shareButtonTapped() {
        guard let image = imageData.image else { return }
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    func deleteButtonTapped() {
        let confirmationAlert = UIAlertController.createDeleteAlert(withTitle: "Delete Photo?", message: "Are you sure you want to delete this photo?") { _ in
            SVProgressHUD.show()
            FirebaseManager.sharedInstance.deleteImage(imageData: self.imageData) { [weak self] result in
                SVProgressHUD.dismiss()
                if let error = result.error {
                    self?.present(UIAlertController.createSimpleAlert(withTitle: "Error", message: error.localizedDescription), animated: true)
                } else {
                    RootViewController.sharedInstance.popViewController()
                }
            }
        }
        present(confirmationAlert, animated: true, completion: nil)
    }
    
    func configureWithImageData(imageData: FBImageData) {
        self.imageData = imageData
    }

}
