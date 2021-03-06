//
//  Result.swift
//  Insecurity-Swift
//
//  Created by Alan Scarpa on 10/31/16.
//  Copyright © 2016 ARC. All rights reserved.
//

import Foundation

public enum Result<T> {
    case Success(T)
    case Failure(Error)
}

extension Result {
    public var isSuccess: Bool {
        guard case .Success(_) = self else { return false }
        return true
    }
    
    public var isFailure: Bool {
        guard case .Failure(_) = self else { return false }
        return true
    }
}

extension Result {
    public var value: T? {
        guard case let .Success(value) = self else { return nil }
        return value
    }
    
    public var error: Error? {
        guard case let .Failure(error) = self else { return nil }
        return error
    }
}
