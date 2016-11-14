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
    }
    
    func configureWithImage(image: UIImage) {
        self.image = image
    }

}
