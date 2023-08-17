//
//  ValidateUserAuthentication.swift
//  NawatechGalleryTests
//
//  Created by Reynaldi on 17/08/23.
//

import XCTest

protocol AuthenticationUserStore {
    func retrieve(thatMatchedWith username: String) -> [String: Any]?
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
    
    func validate(_ user: AuthenticationUserBody) {
        _ = store.retrieve(thatMatchedWith: user.username)
    }
}

final class ValidateUserAuthenticationStore: XCTestCase {
    
    func test_init_didNotRequestUserDataUponCreation() {
        let store = AuthenticationUserStoreSpy()
        let sut = AuthenticationValidationService(store: store)
        
        XCTAssertEqual(store.usernames, [])
    }
    
    func test_validate_requestsUserDataWithAGivenUsername() {
        let store = AuthenticationUserStoreSpy()
        let sut = AuthenticationValidationService(store: store)
        let user = AuthenticationUserBody(username: "test", password: "test")
        
        sut.validate(user)
        
        XCTAssertEqual(store.usernames, [user.username])
    }
    
    //MARK: - Helpers
    
    private final class AuthenticationUserStoreSpy: AuthenticationUserStore {
        
        private(set) var usernames: [String] = []
        
        func retrieve(thatMatchedWith username: String) -> [String : Any]? {
            usernames.append(username)
            return nil
        }
    }
}
