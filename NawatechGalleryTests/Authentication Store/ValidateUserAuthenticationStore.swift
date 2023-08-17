//
//  ValidateUserAuthentication.swift
//  NawatechGalleryTests
//
//  Created by Reynaldi on 17/08/23.
//

import XCTest

final class AuthenticationValidationService {
    
    init(store: Any) {
        
    }
}

final class ValidateUserAuthenticationStore: XCTestCase {
    
    func test_init_didNotRequestUserDataUponCreation() {
        let store = AuthenticationUserStoreSpy()
        let sut = AuthenticationValidationService(store: store)
        
        XCTAssertEqual(store.requests, [])
    }
    
    //MARK: - Helpers
    
    private final class AuthenticationUserStoreSpy {
        
        private(set) var requests: [String] = []
    }
}
