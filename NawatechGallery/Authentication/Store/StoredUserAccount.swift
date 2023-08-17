//
//  StoredUserAccount.swift
//  NawatechGallery
//
//  Created by Reynaldi on 18/08/23.
//

import Foundation

struct StoredUserAccount: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id, fullname, username, password
        case createdAt = "created_at"
        case profileImageURL = "profile_image_url"
    }
    
    let id: String
    let profileImageURL: URL?
    let fullname: String
    let username: String
    let password: String
    let createdAt: Double
    
    var userAccount: UserAccount {
        UserAccount(id: id, profileImageURL: profileImageURL, fullname: fullname, username: username, createdAt: Date(timeIntervalSince1970: createdAt))
    }
}
