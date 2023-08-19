//
//  AuthenticationErrorViewModel.swift
//  NawatechGallery
//
//  Created by Reynaldi on 20/08/23.
//

import Foundation

public struct AuthenticationErrorViewModel {
    public let error: Error?
    public let message: String?
    
    public static var noError: AuthenticationErrorViewModel {
        AuthenticationErrorViewModel(error: nil, message: nil)
    }
    
    public static func error(_ error: Error, message: String) -> AuthenticationErrorViewModel {
        AuthenticationErrorViewModel(error: error, message: message)
    }
}
