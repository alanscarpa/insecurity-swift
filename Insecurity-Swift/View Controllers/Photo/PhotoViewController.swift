//
//  PhotoViewController.swift
//  Insecurity-Swift
//
//  Created by Alan Scarpa on 11/13/16.
//  Copyright © 2016 ARC. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    private var image = UIImage()
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photo"
        photoImageView.image = image
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
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    func deleteButtonTapped() {
        
    }
    
    func configureWithImage(image: UIImage) {
        self.image = image
    }

}
