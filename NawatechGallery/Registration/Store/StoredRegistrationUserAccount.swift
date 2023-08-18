//
//  StoredRegistrationUserAccount.swift
//  NawatechGallery
//
//  Created by Reynaldi on 18/08/23.
//

import Foundation

public struct StoredRegistrationUserAccount: Equatable, Codable {
    public static func == (lhs: StoredRegistrationUserAccount, rhs: StoredRegistrationUserAccount) -> Bool {
        return lhs.id.uuidString == rhs.id.uuidString && lhs.profileImageURL == rhs.profileImageURL && lhs.username == rhs.username && lhs.fullname == rhs.fullname && lhs.password == rhs.password && lhs.createdAt.timeIntervalSince1970 == rhs.createdAt.timeIntervalSince1970
    }
    
    enum CodingKeys: String, CodingKey {
        case id, fullname, username, password
        case createdAt = "created_at"
        case profileImageURL = "profile_image_url"
    }
    
    public let id: UUID
    public let profileImageURL: URL?
    public let fullname: String
    public let username: String
    public let password: String
    public let createdAt: Date
    
    public init(id: UUID, profileImageURL: URL? = nil, fullname: String, username: String, password: String, createdAt: Date) {
        self.id = id
        self.profileImageURL = profileImageURL
        self.fullname = fullname
        self.username = username
        self.password = password
        self.createdAt = createdAt
    }
}
