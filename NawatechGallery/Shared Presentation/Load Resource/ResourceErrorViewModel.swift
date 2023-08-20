//
//  ResourceErrorViewModel.swift
//  NawatechGallery
//
//  Created by Reynaldi on 20/08/23.
//

import Foundation

public struct ResourceErrorViewModel {
    public let error: Error?
    public let message: String?
    
    public static var noError: ResourceErrorViewModel {
        ResourceErrorViewModel(error: nil, message: nil)
    }
    
    public static func error(_ error: Error, message: String) -> ResourceErrorViewModel {
        ResourceErrorViewModel(error: error, message: message)
    }
}
