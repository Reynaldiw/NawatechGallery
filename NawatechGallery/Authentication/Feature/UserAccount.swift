//
//  UserAccount.swift
//  NawatechGallery
//
//  Created by Reynaldi on 18/08/23.
//

import Foundation

public struct UserAccount: Equatable {
    public let id: UUID
    public let profileImageURL: URL?
    public let fullname: String
    public let username: String
    public let createdAt: Date
    
    public init(id: UUID, profileImageURL: URL?, fullname: String, username: String, createdAt: Date) {
        self.id = id
        self.profileImageURL = profileImageURL
        self.fullname = fullname
        self.username = username
        self.createdAt = createdAt
    }
}
