//
//  ValidateUserAuthentication.swift
//  NawatechGalleryTests
//
//  Created by Reynaldi on 17/08/23.
//

import XCTest

protocol AuthenticationUserStore {
    func retrieve(thatMatchedWith username: String) throws -> [[String: Any]]
}

struct AuthenticationUserBody {
    let username: String
    let password: String
}

struct StoredUserAccount: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id, fullname, username, password
        case createdAt = "created_at"
    }
    
    let id: String
    let fullname: String
    let username: String
    let password: String
    let createdAt: Double
}

final class AuthenticationValidationService {
    
    private let store: AuthenticationUserStore
    
    init(store: AuthenticationUserStore) {
        self.store = store
    }
    
    enum Error: Swift.Error {
        case notFound
        case passwordNotMatched
    }
    
    func validate(_ user: AuthenticationUserBody) throws {
        do {
            let receivedUsers = try store.retrieve(thatMatchedWith: user.username)
            guard !receivedUsers.isEmpty else {
                throw Error.notFound
            }
            
            let matchedStoreUser = try receivedUsers
                .map { try JSONSerialization.data(withJSONObject: $0) }
                .map({ data in
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .millisecondsSince1970
                    return try decoder.decode(StoredUserAccount.self, from: data)
                })
                .first(where: { $0.password == user.password })
            
            if matchedStoreUser == nil {
                throw Error.passwordNotMatched
            }
            
        } catch {
            throw error
        }
    }
}

final class ValidateUserAuthenticationStore: XCTestCase {
    
    func test_init_didNotRequestUsersUponCreation() {
        let store = AuthenticationUserStoreStub()
        _ = AuthenticationValidationService(store: store)
        
        XCTAssertEqual(store.usernames, [])
    }
    
    func test_validate_requestsUsersWithAGivenUsername() {
        let store = AuthenticationUserStoreStub()
        let sut = AuthenticationValidationService(store: store)
        let user = AuthenticationUserBody(username: "test", password: "test")
        
        try? sut.validate(user)
        
        XCTAssertEqual(store.usernames, [user.username])
    }
    
    func test_validate_deliversErrorOnErrorStore() {
        let errorStore = NSError(domain: "any error", code: 0)
        let store = AuthenticationUserStoreStub(error: errorStore)
        let sut = AuthenticationValidationService(store: store)
        let user = AuthenticationUserBody(username: "test", password: "test")
        
        do {
            try sut.validate(user)
            XCTFail("Expected to get failure, but got success instead")
        } catch {
            XCTAssertEqual(error as NSError, errorStore)
        }
    }
    
    func test_validate_withAGivenUsername_deliversErrorNotFoundOnEmptyUsers() {
        let store = AuthenticationUserStoreStub()
        let sut = AuthenticationValidationService(store: store)
        let user = AuthenticationUserBody(username: "test", password: "test")
        
        do {
            try sut.validate(user)
            XCTFail("Expected to get failure, but got success instead")
        } catch {
            XCTAssertEqual(error as! AuthenticationValidationService.Error, AuthenticationValidationService.Error.notFound)
        }
    }
    
    func test_validate_deliversErrorOnNonEmptyUsersWithUnmatchingPassword() {
        let user = AuthenticationUserBody(username: "test", password: "test")
        let nonMatchingPasswordStoredUser = StoredUserAccount(id: "any id", fullname: "any fullname", username: user.username, password: "non-match-password", createdAt: Date().timeIntervalSince1970)
        let store = AuthenticationUserStoreStub(storedUsers: [nonMatchingPasswordStoredUser.map()])
        let sut = AuthenticationValidationService(store: store)
        
        do {
            try sut.validate(user)
            XCTFail("Expected to get failure, but got success instead")
        } catch {
            XCTAssertEqual(error as! AuthenticationValidationService.Error, AuthenticationValidationService.Error.passwordNotMatched)
        }
    }
    
    //MARK: - Helpers
    
    private final class AuthenticationUserStoreStub: AuthenticationUserStore {
        
        private(set) var usernames: [String] = []
        
        private let error: Error?
        private let storedUsers: [[String: Any]]
        
        init() {
            self.error = nil
            self.storedUsers = []
        }
        
        init(error: Error) {
            self.error = error
            self.storedUsers = []
        }
        
        init(storedUsers: [[String: Any]]) {
            self.error = nil
            self.storedUsers = storedUsers
        }
        
        func retrieve(thatMatchedWith username: String) throws -> [[String : Any]] {
            usernames.append(username)
            
            if let error = error { throw error }
            
            return storedUsers
        }
    }
}

private extension StoredUserAccount {
    func map() -> [String: Any] {
        return [
            "id": id,
            "fullname": fullname,
            "username": username,
            "password": password,
            "created_at": createdAt
        ]
    }
}
