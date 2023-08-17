//
//  ValidateUserAuthentication.swift
//  NawatechGalleryTests
//
//  Created by Reynaldi on 17/08/23.
//

import XCTest

protocol AuthenticationUserStore {
    func retrieve(thatMatchedWith username: String) -> [[String: Any]]
}

struct AuthenticationUserBody {
    let username: String
    let password: String
}

final class AuthenticationValidationService {
    
    private let store: AuthenticationUserStore
    
    init(store: AuthenticationUserStore) {
        self.store = store
    }
    
    enum Error: Swift.Error {
        case notFound
    }
    
    func validate(_ user: AuthenticationUserBody) throws {
        let receivedUsers = store.retrieve(thatMatchedWith: user.username)
        guard !receivedUsers.isEmpty else {
            throw Error.notFound
        }
    }
}

final class ValidateUserAuthenticationStore: XCTestCase {
    
    func test_init_didNotRequestUserDataUponCreation() {
        let store = AuthenticationUserStoreSpy()
        _ = AuthenticationValidationService(store: store)
        
        XCTAssertEqual(store.usernames, [])
    }
    
    func test_validate_requestsUserDataWithAGivenUsername() {
        let store = AuthenticationUserStoreSpy()
        let sut = AuthenticationValidationService(store: store)
        let user = AuthenticationUserBody(username: "test", password: "test")
        
        try? sut.validate(user)
        
        XCTAssertEqual(store.usernames, [user.username])
    }
    
    func test_validate_withAGivenUsername_deliversErrorNotFoundOnEmptyUser() {
        let store = AuthenticationUserStoreSpy()
        let sut = AuthenticationValidationService(store: store)
        let user = AuthenticationUserBody(username: "test", password: "test")
        
        do {
            try sut.validate(user)
            XCTFail("Expected to get failure, but got success instead")
        } catch {
            XCTAssertEqual(error as! AuthenticationValidationService.Error, AuthenticationValidationService.Error.notFound)
        }
    }
    
    //MARK: - Helpers
    
    private final class AuthenticationUserStoreSpy: AuthenticationUserStore {
        
        private(set) var usernames: [String] = []
        
        func retrieve(thatMatchedWith username: String) -> [[String : Any]] {
            usernames.append(username)
            return []
        }
    }
}
