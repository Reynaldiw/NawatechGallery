//
//  StoredUserAccountUseCaseTests.swift
//  NawatechGalleryTests
//
//  Created by Reynaldi on 18/08/23.
//

import XCTest
import NawatechGallery

final class RegistrationUserAccountService {
    
    private let store: RegistrationUserAccountStore
    private let dateCreated: () -> Date
    private let idCreated: () -> UUID
    
    init(store: RegistrationUserAccountStore, dateCreated: @escaping () -> Date = Date.init, idCreated: @escaping () -> UUID = UUID.init) {
        self.store = store
        self.dateCreated = dateCreated
        self.idCreated = idCreated
    }
    
    func register(_ user: RegistrationUserAccount) throws {
        let storedUser = StoredRegistrationUserAccount(
            id: idCreated(),
            profileImageURL: nil,
            fullname: user.fullname,
            username: user.username,
            password: user.password,
            createdAt: dateCreated())
        
        try store.insert(storedUser)
    }
}

final class StoredUserAccountUseCaseTests: XCTestCase {
    
    func test_init_didNotInsertUserUponCreation() {
        let store = UserAccountStoreStub()
        let _ = RegistrationUserAccountService(store: store)
        
        XCTAssertEqual(store.messages, [])
    }
    
    func test_register_insertsUser() {
        let userCreatedDate = Date()
        let userID = UUID()
        let user = uniqueUser(id: userID, createdAt: userCreatedDate)
        let store = UserAccountStoreStub()
        let sut = RegistrationUserAccountService(
            store: store,
            dateCreated: { userCreatedDate },
            idCreated: { userID })
        
        try? sut.register(user.registration)
        
        XCTAssertEqual(store.messages, [.insert(user.stored)])
    }
    
    func test_register_deliversErrorOnInsertionError() throws {
        let errorStore = NSError(domain: "any-error", code: 0)
        let store = UserAccountStoreStub(error: errorStore)
        let sut = RegistrationUserAccountService(store: store)
        
        XCTAssertThrowsError(try sut.register(anyRegistrationUser()))
    }
    
    func test_register_doesNotDeliversErrorOnSuccessfulInsertion() {
        let store = UserAccountStoreStub()
        let sut = RegistrationUserAccountService(store: store)
        
        XCTAssertNoThrow(try sut.register(anyRegistrationUser()))
    }
    
    //MARK: - Helpers
    
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
        
        init(error: Error? = nil) {
            self.error = error
        }
        
        func insert(_ user: StoredRegistrationUserAccount) throws {
            messages.append(.insert(user))
            
            if let error = error {
                throw error
            }
        }
    }
}
