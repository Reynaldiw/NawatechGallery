//
//  ResourceErrorViewModel.swift
//  NawatechGallery
//
//  Created by Reynaldi on 21/08/23.
//

import Foundation

public struct ResourceErrorViewModel {
    public let error: Swift.Error?
    public let message: String?
    
    static var noError: ResourceErrorViewModel {
        return ResourceErrorViewModel(error: nil, message: nil)
    }
    
    static func error(_ error: Error, message: String) -> ResourceErrorViewModel {
        return ResourceErrorViewModel(error: error, message: message)
    }
}
