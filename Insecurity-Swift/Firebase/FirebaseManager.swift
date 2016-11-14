//
//  FirebaseManager.swift
//  Insecurity-Swift
//
//  Created by Alan Scarpa on 10/31/16.
//  Copyright © 2016 ARC. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

protocol FirebaseManagerDelegate: class {
    func currentUserDidSignOut()
}

class FirebaseManager {
    
    static let sharedInstance = FirebaseManager()
    weak var delegate: FirebaseManagerDelegate?
    
    let storage = FIRStorage.storage()
    let databaseRef = FIRDatabase.database().reference()
    
    private var currentUserIsSignedOut: Bool {
        return FIRAuth.auth()?.currentUser == nil
    }
    
    private var authStateListener: FIRAuthStateDidChangeListenerHandle!
    
    private init() {}
    
    func listenForAuthStateChanges() {
        authStateListener = FIRAuth.auth()?.addStateDidChangeListener(authStateChangedHandler)
    }
    
    func stopListeningForAuthStateChanges() {
        FIRAuth.auth()?.removeStateDidChangeListener(authStateListener)
    }
    
    private func authStateChangedHandler(auth: FIRAuth, user: FIRUser?) -> Swift.Void {
        if currentUserIsSignedOut {
            delegate?.currentUserDidSignOut()
        }
    }
    
    func signOutCurrentUser(completion: @escaping (Result<Void>) -> Void) {
        do {
            try FIRAuth.auth()?.signOut()
            completion(.Success())
        } catch {
            completion(.Failure(error))
        }
    }
    
    func put(photoData: Data, completion: @escaping (Result<Void>) -> Void) {
        let userID = FIRAuth.auth()!.currentUser!.uid
        let fileName = databaseRef.child("users").child(userID).child("images").childByAutoId().key
        
        let storageRef = storage.reference(forURL: "gs://insecurity-40a93.appspot.com")
        let imagesRef = storageRef.child("images/\(userID)")
        
        let fileRef = imagesRef.child(fileName)
        
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        _ = fileRef.put(photoData, metadata: metadata) { [weak self] metadata, error in
            if let error = error {
                completion(.Failure(error))
            } else {
                let downloadURLString = metadata!.downloadURL()!.absoluteString
                self?.databaseRef.child("users")
                    .child(userID)
                    .child("images")
                    .child(fileName)
                    .setValue(["downloadURL" : downloadURLString, "date" : NSDate().timeIntervalSince1970], withCompletionBlock: {  error, ref in
                        if let error = error {
                            completion(.Failure(error))
                        } else {
                            completion(.Success())
                        }
                    })
            }
        }
    }
    
    func getPhoto(url: URL, completion: @escaping (Result<UIImage>) -> Void) {
        //let storageRef = storage.reference(forURL: "gs://insecurity-40a93.appspot.com")
        //let userID = FIRAuth.auth()!.currentUser!.uid
        
        //let imagesRef = storageRef.child("images/\(userID)")
        
        let httpsReference = storage.reference(forURL: url.absoluteString)
        httpsReference.data(withMaxSize: 1 * 1024 * 1024) { (data, error) in
            if error != nil {
                completion(.Failure(error!))
            } else if let data = data, let image = UIImage(data: data) {
                completion(.Success(image))
            }
        }
    }
    
    
    func getCurrentUserImageURLs(completion: @escaping (Result<[FBImageData]>) -> Void) {
        var imageObjects = [FBImageData]()
        let userID = FIRAuth.auth()!.currentUser!.uid
        databaseRef.child("users").child(userID).child("images").observeSingleEvent(of: .value, with: { (snapshot) in
            let allValues = snapshot.value as! NSDictionary
            for (_, value) in allValues {
                let valueDictionary = value as! NSDictionary
                let urlString = valueDictionary["downloadURL"] as? String ?? ""
                let dateDouble = valueDictionary["date"] as? Double ?? 0

                let url = URL(string: urlString)
                let date = Date(timeIntervalSince1970: TimeInterval(dateDouble))
                let imageObject = FBImageData(url: url, date: date, image: nil)
                imageObjects.append(imageObject)
            }
            completion(.Success(imageObjects))
        }) { (error) in
            completion(.Failure(error))
        }
    }
}

struct FBImageData {
    var url: URL!
    var date = Date()
    var image: UIImage?
}
