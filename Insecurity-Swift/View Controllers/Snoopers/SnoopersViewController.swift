//
//  SnoopersViewController.swift
//  Insecurity-Swift
//
//  Created by Alan Scarpa on 11/1/16.
//  Copyright © 2016 ARC. All rights reserved.
//

import UIKit

class SnoopersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ImageLoaderDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    let collectionViewCellReuseIdentifier = "SnoopersCollectionViewCell"
    let maxNumberOfPhotosPerRow: CGFloat = 4
    var collectionViewCellSize: CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / maxNumberOfPhotosPerRow) - (maxNumberOfPhotosPerRow - 1), height: UIScreen.main.bounds.height / maxNumberOfPhotosPerRow)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Snoopers"
        RootViewController.sharedInstance.showNavigationBar = true
        setUpCollectionView()
        ImageLoader.sharedInstance.delegate = self
        ImageLoader.sharedInstance.downloadAllImages()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        RootViewController.sharedInstance.showNavigationBar = false
    }

    func setUpCollectionView() {
        let snoopersCellNib = UINib(nibName: collectionViewCellReuseIdentifier, bundle: nil)
        collectionView.register(snoopersCellNib, forCellWithReuseIdentifier: collectionViewCellReuseIdentifier)
        
        collectionViewFlowLayout.itemSize = collectionViewCellSize
        collectionViewFlowLayout.minimumLineSpacing = maxNumberOfPhotosPerRow
        collectionViewFlowLayout.minimumInteritemSpacing = maxNumberOfPhotosPerRow / 2

    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImageLoader.sharedInstance.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellReuseIdentifier, for: indexPath) as! SnoopersCollectionViewCell
        cell.configureWithImage(image: ImageLoader.sharedInstance.images[indexPath.row].image)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    // MARK: - ImageLoaderDelegate
    
    func finishedDownloadingImages(error: Error?) {
        if let error = error {
            present(UIAlertController.createSimpleAlert(withTitle: "Error", message: error.localizedDescription), animated: true, completion: nil)
        } else {
            collectionView.reloadData()
        }
    }

}
