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
}
