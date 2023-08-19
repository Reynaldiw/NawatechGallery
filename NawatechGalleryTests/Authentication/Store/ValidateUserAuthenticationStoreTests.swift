//
//  ValidateUserAuthentication.swift
//  NawatechGalleryTests
//
//  Created by Reynaldi on 17/08/23.
//

import XCTest
import NawatechGallery

final class ValidateUserAuthenticationStoreTests: XCTestCase {
    
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
        let nonMatchingPasswordStoredUser = makeUser(username: userRequest.username, password: "non-matching-password", profileImageURL: URL(string: "https://any-url.com"))
        let (sut, _) = makeSUT(storedUsers: [nonMatchingPasswordStoredUser.json])
        
        expect(sut, toValidate: userRequest, toCompleteWith: failed(AuthenticationValidationService.Error.passwordNotMatched))
    }
    
    func test_validate_deliversUserOnNonEmptyStoredUserAndMatchedPassword() {
        let userRequest = makeAnyUserBody()
        let matchingPasswordStoredUser = makeUser(username: userRequest.username, password: userRequest.password)
        let (sut, _) = makeSUT(storedUsers: [matchingPasswordStoredUser.json])
        
        
        expect(sut, toValidate: userRequest, toCompleteWith: .success(matchingPasswordStoredUser.model))
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
            XCTAssertEqual(receivedUser.id, expectedUser.id, file: file, line: line)
            XCTAssertEqual(receivedUser.username, expectedUser.username, file: file, line: line)
            XCTAssertEqual(receivedUser.fullname, expectedUser.fullname, file: file, line: line)
            XCTAssertEqual(receivedUser.profileImageURL, expectedUser.profileImageURL, file: file, line: line)
            XCTAssertEqual(receivedUser.createdAt.timeIntervalSince1970, expectedUser.createdAt.timeIntervalSince1970, file: file, line: line)
            
        case let (.failure(receivedError as AuthenticationValidationService.Error), .failure(expectedError as AuthenticationValidationService.Error)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            
        case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            
        default:
            XCTFail("Expected to get \(expectedResult), but got \(receivedResult) instead", file: file, line: line)
        }
    }
    
    private func makeUser(username: String, password: String, profileImageURL: URL? = nil) -> (json: [String: Any], model: UserAccount) {
        let model = UserAccount(id: UUID(), profileImageURL: profileImageURL, fullname: "any-fullname", username: username, createdAt: Date())
        
        var json: [String: Any] = [
            "id": model.id.uuidString,
            "fullname": model.fullname,
            "username": model.username,
            "password": password,
            "created_at": model.createdAt.timeIntervalSince1970
        ]
        
        if let profileImageURL = model.profileImageURL {
            json["profile_image_url"] = profileImageURL.absoluteString
        }
        
        return (json, model)
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
