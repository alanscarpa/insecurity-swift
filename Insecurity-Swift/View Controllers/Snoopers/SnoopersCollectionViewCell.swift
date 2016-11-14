//
//  SnoopersCollectionViewCell.swift
//  Insecurity-Swift
//
//  Created by Alan Scarpa on 11/1/16.
//  Copyright © 2016 ARC. All rights reserved.
//

import UIKit

class SnoopersCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!

    func configureWithImage(image: UIImage?) {
        imageView.image = image
    }

}
