//
//  StoredUserAccountUseCaseTests.swift
//  NawatechGalleryTests
//
//  Created by Reynaldi on 18/08/23.
//

import XCTest

struct RegistrationUserAccount {
    let fullname: String
    let username: String
    let password: String
}

struct StoredRegistrationUserAccount: Equatable {
    static func == (lhs: StoredRegistrationUserAccount, rhs: StoredRegistrationUserAccount) -> Bool {
        return lhs.id.uuidString == rhs.id.uuidString && lhs.profileImageURL == rhs.profileImageURL && lhs.username == rhs.username && lhs.fullname == rhs.fullname && lhs.password == rhs.password && lhs.createdAt.timeIntervalSince1970 == rhs.createdAt.timeIntervalSince1970
    }
    
    let id: UUID
    let profileImageURL: URL?
    let fullname: String
    let username: String
    let password: String
    let createdAt: Date
}

protocol RegistrationUserAccountStore {
    func insert(_ user: StoredRegistrationUserAccount)
}

final class RegistrationUserAccountService {
    
    private let store: RegistrationUserAccountStore
    private let dateCreated: () -> Date
    private let idCreated: () -> UUID
    
    init(store: RegistrationUserAccountStore, dateCreated: @escaping () -> Date = Date.init, idCreated: @escaping () -> UUID = UUID.init) {
        self.store = store
        self.dateCreated = dateCreated
        self.idCreated = idCreated
    }
    
    func register(_ user: RegistrationUserAccount) {
        let storedUser = StoredRegistrationUserAccount(
            id: idCreated(),
            profileImageURL: nil,
            fullname: user.fullname,
            username: user.username,
            password: user.password,
            createdAt: dateCreated())
        store.insert(storedUser)
    }
}

final class StoredUserAccountUseCaseTests: XCTestCase {
    
    func test_init_didNotInsertUserUponCreation() {
        let store = UserAccountStoreStub()
        let sut = RegistrationUserAccountService(store: store)
        
        XCTAssertEqual(store.messages, [])
    }
    
    func test_register_insertsUser() {
        let userCreatedDate = Date()
        let userID = UUID()
        let store = UserAccountStoreStub()
        let sut = RegistrationUserAccountService(
            store: store,
            dateCreated: { userCreatedDate },
            idCreated: { userID })
        let registrationUser = RegistrationUserAccount(
            fullname: "any-fullname",
            username: "any-username",
            password: "any-password")
        
        sut.register(registrationUser)
        
        let storedUser = StoredRegistrationUserAccount(id: userID, profileImageURL: nil, fullname: registrationUser.fullname, username: registrationUser.username, password: registrationUser.password, createdAt: userCreatedDate)
        XCTAssertEqual(store.messages, [.insert(storedUser)])
        
    }
    
    //MARK: - Helpers
    
    private class UserAccountStoreStub: RegistrationUserAccountStore {
        
        enum Message: Equatable {
            case insert(StoredRegistrationUserAccount)
        }
        
        private(set) var messages: [Message] = []
        
        func insert(_ user: StoredRegistrationUserAccount) {
            messages.append(.insert(user))
        }
    }
}
