//
//  RegistrationUserAccount.swift
//  NawatechGallery
//
//  Created by Reynaldi on 18/08/23.
//

import Foundation

public struct RegistrationUserAccount {
    public let fullname: String
    public let username: String
    public let password: String
    
    public init(fullname: String, username: String, password: String) {
        self.fullname = fullname
        self.username = username
        self.password = password
    }
}
