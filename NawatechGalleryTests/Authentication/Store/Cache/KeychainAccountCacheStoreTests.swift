//
//  KeychainAccountCacheStoreTests.swift
//  NawatechGalleryTests
//
//  Created by Reynaldi on 20/08/23.
//

import XCTest

protocol AccountCacheStoreRetriever {
    func retrieve() throws -> String?
}

final class KeychainAccountCacheStore {
    
    enum Error: Swift.Error {
        case failedToRetrieve
    }
    
    private let storeKey: String
    
    init(storeKey: String) {
        self.storeKey = storeKey
    }
}

extension KeychainAccountCacheStore: AccountCacheStoreRetriever {
    func retrieve() throws -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: storeKey,
            kSecReturnData: kCFBooleanTrue as Any,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
                
        let accountID = result as? String
        return accountID
    }
}

final class KeychainAccountCacheStoreTests: XCTestCase {
    
    func test_retrieveAccountID_deliversEmptyValueOnEmptyCache() {
        let sut = KeychainAccountCacheStore(storeKey: "keychain.account.store.test.key")
        
        do {
            let accountID = try sut.retrieve()
            XCTAssertNil(accountID, "Should return empty value on empty cache")
            
        } catch {
            XCTFail("Expected to succeed with empty value")
        }
    }
}
