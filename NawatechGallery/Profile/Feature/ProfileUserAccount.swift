//
//  ProfileUserAccount.swift
//  NawatechGallery
//
//  Created by Reynaldi on 21/08/23.
//

import Foundation

public struct ProfileUserAccount: Equatable {
    public let id: UUID
    public let profileImageURL: URL?
    public let fullname: String
    
    public init(id: UUID, profileImageURL: URL?, fullname: String) {
        self.id = id
        self.profileImageURL = profileImageURL
        self.fullname = fullname
    }
}
