//
//  ProfileUserAccountMapper.swift
//  NawatechGallery
//
//  Created by Reynaldi on 21/08/23.
//

import Foundation

public final class ProfileUserAccountMapper {
    
    private struct StoredProfileUserAccount: Decodable {
        enum CodingKeys: String, CodingKey {
            case id, fullname, username, password
            case createdAt = "created_at"
            case profileImageURL = "profile_image_url"
        }
        
        let id: UUID
        let profileImageURL: URL?
        let fullname: String
        let password: String
        let username: String
        let createdAt: Date
        
        var model: ProfileUserAccount {
            ProfileUserAccount(id: id, profileImageURL: profileImageURL, fullname: fullname)
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data) throws -> ProfileUserAccount {
        guard let storedProfileAccount = try? JSONDecoder().decode(StoredProfileUserAccount.self, from: data) else {
            throw Error.invalidData
        }
        
        return storedProfileAccount.model
    }
}
