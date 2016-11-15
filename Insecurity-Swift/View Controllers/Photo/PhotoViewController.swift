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
        RootViewController.sharedInstance.showToolBar = true
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        setToolbarItems([shareButton, spacer, deleteButton], animated: true)
    }
    
    func shareButtonTapped() {
        
    }
    
    func deleteButtonTapped() {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        RootViewController.sharedInstance.showToolBar = false
    }
    
    func configureWithImage(image: UIImage) {
        self.image = image
    }

}
