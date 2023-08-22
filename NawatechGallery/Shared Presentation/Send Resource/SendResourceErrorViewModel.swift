//
//  SendResourceErrorViewModel.swift
//  NawatechGallery
//
//  Created by Reynaldi on 20/08/23.
//

import Foundation

public struct SendResourceErrorViewModel {
    public let error: Error?
    public let message: String?
    
    public static var noError: SendResourceErrorViewModel {
        SendResourceErrorViewModel(error: nil, message: nil)
    }
    
    public static func error(_ error: Error, message: String) -> SendResourceErrorViewModel {
        SendResourceErrorViewModel(error: error, message: message)
    }
}
