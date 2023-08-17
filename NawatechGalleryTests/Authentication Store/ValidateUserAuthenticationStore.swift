//
//  ValidateUserAuthentication.swift
//  NawatechGalleryTests
//
//  Created by Reynaldi on 17/08/23.
//

import XCTest
import NawatechGallery

struct AuthenticationUserBody {
    let username: String
    let password: String
}

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
}

struct UserAccount: Equatable {
    let id: String
    let profileImageURL: URL?
    let fullname: String
    let username: String
    let createdAt: Date
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
    
    func validate(_ user: AuthenticationUserBody) throws -> UserAccount {
        do {
            let receivedUsers = try store.retrieve(thatMatchedWith: user.username)
            guard !receivedUsers.isEmpty else {
                throw Error.notFound
            }
            
            let matchedStoredUser = try receivedUsers
                .map { try JSONSerialization.data(withJSONObject: $0) }
                .map { try JSONDecoder().decode(StoredUserAccount.self, from: $0) }
                .first(where: { $0.password == user.password })
            
            guard let matchedStoredUser = matchedStoredUser else {
                throw Error.passwordNotMatched
            }
            
            return matchedStoredUser.toModel()
            
        } catch {
            throw error
        }
    }
}

final class ValidateUserAuthenticationStore: XCTestCase {
    
    func test_init_didNotRequestUsersUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.usernames, [])
    }
    
    func test_validate_requestsUsersWithAGivenUsername() {
        let (sut, store) = makeSUT()
        let user = makeAnyUserBody()

        _ = try? sut.validate(user)
        
        XCTAssertEqual(store.usernames, [user.username])
    }
    
    func test_validate_deliversErrorOnErrorStore() {
        let errorStore = NSError(domain: "any error", code: 0)
        let (sut, _) = makeSUT(errorStore: errorStore)
        
        expect(sut, toCompleteWith: .failure(errorStore))
    }
    
    func test_validate_withAGivenUsername_deliversErrorNotFoundOnEmptyUsers() {
        let (sut, _) = makeSUT(storedUsers: [])
        
        expect(sut, toCompleteWith: failed(AuthenticationValidationService.Error.notFound))
    }
    
    func test_validate_deliversErrorOnNonEmptyUsersWithUnmatchingPassword() {
        let userRequest = makeAnyUserBody()
        let nonMatchingPasswordStoredUser = StoredUserAccount(
            id: "any id",
            profileImageURL: URL(string: "https://any-url.com"),
            fullname: "any fullname",
            username: userRequest.username,
            password: "non-match-password",
            createdAt: Date().timeIntervalSince1970)
        let (sut, _) = makeSUT(storedUsers: [nonMatchingPasswordStoredUser.map()])
        
        expect(sut, toValidate: userRequest, toCompleteWith: failed(AuthenticationValidationService.Error.passwordNotMatched))
    }
    
    func test_validate_deliversUserOnNonEmptyStoredUserAndMatchedPassword() {
        let userRequest = makeAnyUserBody()
        let matchedPasswordStoredUser = StoredUserAccount(
            id: "any id",
            profileImageURL: nil,
            fullname: "any fullname",
            username: userRequest.username,
            password: userRequest.password,
            createdAt: Date().timeIntervalSince1970)
        let (sut, _) = makeSUT(storedUsers: [matchedPasswordStoredUser.map()])
        
        let userAccount: UserAccount = matchedPasswordStoredUser.toModel()
        expect(sut, toValidate: userRequest, toCompleteWith: .success(userAccount))
    }
    
    //MARK: - Helpers
    
    private func makeSUT(
        errorStore: Error? = nil,
        storedUsers: [[String: Any]] = []
    ) -> (sut: AuthenticationValidationService, store: AuthenticationUserStoreStub) {
        let store = AuthenticationUserStoreStub(storedUsers: storedUsers, error: errorStore)
        let sut = AuthenticationValidationService(store: store)
        
        return (sut, store)
    }
    
    private func expect(
        _ sut: AuthenticationValidationService,
        toValidate authenticationUserBody: AuthenticationUserBody = AuthenticationUserBody(username: "test", password: "test"),
        toCompleteWith expectedResult: Result<UserAccount, Error>,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let receivedResult = Result { try sut.validate(authenticationUserBody) }
        
        switch (receivedResult, expectedResult) {
        case let (.success(receivedUser), .success(expectedUser)):
            XCTAssertEqual(receivedUser, expectedUser, file: file, line: line)
            
        case let (.failure(receivedError as AuthenticationValidationService.Error), .failure(expectedError as AuthenticationValidationService.Error)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            
        case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            
        default:
            XCTFail("Expected to get \(expectedResult), but got \(receivedResult) instead", file: file, line: line)
        }
    }
    
    private func failed(_ error: AuthenticationValidationService.Error) -> Result<UserAccount, Error> {
        .failure(error)
    }
    
    private func makeAnyUserBody() -> AuthenticationUserBody {
        AuthenticationUserBody(username: "test", password: "test")
    }
    
    private final class AuthenticationUserStoreStub: AuthenticationUserStore {
        
        private(set) var usernames: [String] = []
        
        private let error: Error?
        private let storedUsers: [[String: Any]]
        
        init(storedUsers: [[String: Any]], error: Error?) {
            self.error = error
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
        var value: [String: Any] = [
            "id": id,
            "fullname": fullname,
            "username": username,
            "password": password,
            "created_at": createdAt
        ]
        
        if let profileImageURL = profileImageURL {
            value["profile_image_url"] = profileImageURL.absoluteString
        }
        
        return value
    }
    
    func toModel() -> UserAccount {
        return UserAccount(id: id, profileImageURL: profileImageURL, fullname: fullname, username: username, createdAt: Date(timeIntervalSince1970: createdAt))
    }
}
