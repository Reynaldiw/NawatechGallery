//
//  StoredUserAccountUseCaseTests.swift
//  NawatechGalleryTests
//
//  Created by Reynaldi on 18/08/23.
//

import XCTest
import NawatechGallery

final class StoredUserAccountUseCaseTests: XCTestCase {
    
    func test_init_didNotInsertUserUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.messages, [])
    }
    
    func test_register_insertsUser() {
        let userCreatedDate = Date()
        let userID = UUID()
        let user = uniqueUser(id: userID, createdAt: userCreatedDate)
        let (sut, store) = makeSUT(date: { userCreatedDate }, id: { userID })
        
        try? sut.register(user.registration)
        
        XCTAssertEqual(store.messages, [.insert(user.stored)])
    }
    
    func test_register_deliversErrorOnUsernameAlreadyTaken() throws {
        let user = uniqueUser(id: UUID(), createdAt: Date())
        let existingUser = user.stored
        let (sut, _) = makeSUT(existingUser: existingUser)
        
        XCTAssertThrowsError(try sut.register(user.registration), "Expected to throw error username already taken") { error in
            XCTAssertEqual(error as? RegistrationUserAccountService.Error, RegistrationUserAccountService.Error.usernameAlreadyTaken)
        }
    }
    
    func test_register_deliversErrorOnInsertionError() throws {
        let errorStore = NSError(domain: "any-error", code: 0)
        let (sut, _) = makeSUT(error: errorStore)
        
        XCTAssertThrowsError(try sut.register(anyRegistrationUser()))
    }
    
    func test_register_doesNotDeliversErrorOnSuccessfulInsertion() {
        let (sut, _) = makeSUT()
        
        XCTAssertNoThrow(try sut.register(anyRegistrationUser()))
    }
    
    //MARK: - Helpers
    
    private func makeSUT(
        date: @escaping () -> Date = Date.init,
        id: @escaping () -> UUID = UUID.init,
        error: Error? = nil,
        existingUser: StoredRegistrationUserAccount? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: RegistrationUserAccountService, store: UserAccountStoreStub) {
        let store = UserAccountStoreStub(error: error, existingUser: existingUser)
        let sut = RegistrationUserAccountService(
            store: store,
            dateCreated: date,
            idCreated: id)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func uniqueUser(id: UUID, createdAt date: Date) -> (registration: RegistrationUserAccount, stored: StoredRegistrationUserAccount) {
        let registrationUser = anyRegistrationUser()
        let storedUser = StoredRegistrationUserAccount(id: id, profileImageURL: nil, fullname: registrationUser.fullname, username: registrationUser.username, password: registrationUser.password, createdAt: date)
        return (registrationUser, storedUser)
    }
    
    private func anyRegistrationUser() -> RegistrationUserAccount {
        RegistrationUserAccount(fullname: "any-fullname", username: "any-username", password: "any-password")
    }
    
    private class UserAccountStoreStub: RegistrationUserAccountStore {
        
        enum Message: Equatable {
            case insert(StoredRegistrationUserAccount)
        }
        
        private(set) var messages: [Message] = []
        
        private let error: Error?
        private let existingUser: StoredRegistrationUserAccount?
        
        init(error: Error?, existingUser: StoredRegistrationUserAccount?) {
            self.error = error
            self.existingUser = existingUser
        }
        
        func insert(_ user: StoredRegistrationUserAccount) throws {
            messages.append(.insert(user))
            
            if let error = error {
                throw error
            }
        }
        
        func retrieve(thatMathedWithUsername username: String) -> StoredRegistrationUserAccount? {
            return existingUser
        }
    }
}
