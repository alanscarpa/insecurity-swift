//
//  UserDefaultsManager.swift
//  Insecurity-Swift
//
//  Created by Alan Scarpa on 1/7/17.
//  Copyright © 2017 ARC. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private init() {}
    private let hasTakenFirstPhotoKey = "hasTakenFirstPhoto"
    
    var hasTakenFirstPhoto: Bool {
        return UserDefaults.standard.bool(forKey: hasTakenFirstPhotoKey)
    }
    
    func setFirstPhotoTaken() {
        UserDefaults.standard.set(true, forKey: hasTakenFirstPhotoKey)
    }
    
}
