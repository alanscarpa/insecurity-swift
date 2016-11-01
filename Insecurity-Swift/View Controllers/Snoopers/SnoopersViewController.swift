//
//  SnoopersViewController.swift
//  Insecurity-Swift
//
//  Created by Alan Scarpa on 11/1/16.
//  Copyright © 2016 ARC. All rights reserved.
//

import UIKit

class SnoopersViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let collectionViewCellReuseIdentifier = "SnoopersCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RootViewController.sharedInstance.showNavigationBar = true
        setUpCollectionView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        RootViewController.sharedInstance.showNavigationBar = false
    }
    

    func setUpCollectionView() {
        let snoopersCellNib = UINib(nibName: collectionViewCellReuseIdentifier, bundle: nil)
        collectionView.register(snoopersCellNib, forCellWithReuseIdentifier: collectionViewCellReuseIdentifier)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellReuseIdentifier, for: indexPath) as! SnoopersCollectionViewCell
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

}
