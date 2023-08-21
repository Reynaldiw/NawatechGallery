//
//  ProfileUserAccountMapperTests.swift
//  NawatechGalleryTests
//
//  Created by Reynaldi on 21/08/23.
//

import XCTest
import NawatechGallery

final class ProfileUserAccountMapperTests: XCTestCase {
    func test_map_deliversErrorOnInvalidData() throws {
        let invalidData = Data("Invalid values".utf8)
        
        XCTAssertThrowsError(
            try ProfileUserAccountMapper.map(invalidData)
        )
    }
    
    func test_map_deliversErrorOnEmptyValues() throws {
        XCTAssertThrowsError(try ProfileUserAccountMapper.map(makeUserValues([])))
    }
    
    func test_map_deliversFirstItemOnNonEmptyValues() throws {
        let user1 = makeUser(
            id: UUID(),
            profileImageURL: nil,
            fullname: "a fullname",
            username: "a username",
            password: "a password",
            createdAt: Date())
        
        let user2 = makeUser(
            id: UUID(),
            profileImageURL: URL(string: "https://another-url.com"),
            fullname: "another fullname",
            username: "another username",
            password: "another password",
            createdAt: Date())
        
        do {
            let result = try ProfileUserAccountMapper.map(makeUserValues([user1.value, user2.value]))
            XCTAssertEqual(result, user1.model)
        } catch {
            XCTFail("Expected to succeed with result, but got \(error) instead")
        }
    }
    
    //MARK: - Helpers
    
    private func makeUser(
        id: UUID,
        profileImageURL: URL?,
        fullname: String,
        username: String,
        password: String,
        createdAt date: Date
    ) -> (model: ProfileUserAccount, value: [String: Any]) {
        let model = ProfileUserAccount(id: id, profileImageURL: profileImageURL, fullname: fullname)
        var value: [String: Any] = [
            "id": id.uuidString,
            "fullname": fullname,
            "username": username,
            "password": password,
            "created_at": date.timeIntervalSince1970,
        ]
        
        if let profileImageURL = profileImageURL {
            value["profile_image_url"] = profileImageURL.absoluteString
        }
        
        return (model, value)
    }
    
    private func makeUserValues(_ users: [[String: Any]]) -> Data {
        return try! JSONSerialization.data(withJSONObject: users)
    }
}
