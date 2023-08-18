//
//  StoredUserAccountUseCaseTests.swift
//  NawatechGalleryTests
//
//  Created by Reynaldi on 18/08/23.
//

import XCTest

final class RegistrationUserAccountService {
    
}

final class StoredUserAccountUseCaseTests: XCTestCase {
    
    func test_init_didNotInsertUserUponCreation() {
        let store = UserAccountStoreStub()
        let sut = RegistrationUserAccountService()
        
        XCTAssertEqual(store.users, [])
    }
    
    //MARK: - Helpers
    
    private class UserAccountStoreStub {
        
        private(set) var users: [String] = []
    }
}
