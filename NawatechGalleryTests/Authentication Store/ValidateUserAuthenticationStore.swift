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

final class AuthenticationValidationService {
    
    private let store: AuthenticationUserStore
    
    init(store: AuthenticationUserStore) {
        self.store = store
    }
    
    enum Error: Swift.Error {
        case notFound
    }
    
    func validate(_ user: AuthenticationUserBody) throws {
        do {
            let receivedUsers = try store.retrieve(thatMatchedWith: user.username)
            guard !receivedUsers.isEmpty else {
                throw Error.notFound
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
    
    //MARK: - Helpers
    
    private final class AuthenticationUserStoreStub: AuthenticationUserStore {
        
        private(set) var usernames: [String] = []
        
        private let error: Error?
        
        init() {
            self.error = nil
        }
        
        init(error: Error) {
            self.error = error
        }
        
        func retrieve(thatMatchedWith username: String) throws -> [[String : Any]] {
            usernames.append(username)
            
            if let error = error { throw error }
            
            return []
        }
    }
}
