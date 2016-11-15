//
//  ImageLoader.swift
//  Insecurity-Swift
//
//  Created by Alan Scarpa on 11/13/16.
//  Copyright © 2016 ARC. All rights reserved.
//

import UIKit
import Foundation

protocol ImageLoaderDelegate: class {
    func finishedDownloadingImages(error: Error?)
}

class ImageLoader {
    
    static let sharedInstance = ImageLoader()
    weak var delegate: ImageLoaderDelegate?
    
    private var imageData = [FBImageData]()
    var images = [FBImageData]()
    
    func downloadAllImages() {
        FirebaseManager.sharedInstance.getCurrentUserImageURLs { [weak self] result in
            switch result {
            case .Success(let imageData):
                self?.imageData = imageData
                self?.downloadImagesFromFirebase()
            case .Failure(let error):
                self?.delegate?.finishedDownloadingImages(error: error)
            }
        }
    }
    
    func clearImages() {
        imageData = [FBImageData]()
        images = [FBImageData]()
    }
    
    private func downloadImagesFromFirebase() {
        let processGroup = DispatchGroup()
        var error: Error?
        for data in imageData {
            guard !images.contains(where: { $0.url == data.url }) else { continue }
            processGroup.enter()
            FirebaseManager.sharedInstance.getPhoto(url: data.url, completion: { [weak self] result in
                switch result {
                case .Success(let image):
                    let imageData = FBImageData(url: data.url, date: data.date, image: image)
                    self?.images.append(imageData)
                case .Failure(let imageDownloadError):
                    error = imageDownloadError
                }
                processGroup.leave()
            })
        }
        processGroup.notify(queue: DispatchQueue.main, work: DispatchWorkItem {
            self.images.sort(by: { $0.date < $1.date })
            self.delegate?.finishedDownloadingImages(error: error)
        })
    }
    
}
