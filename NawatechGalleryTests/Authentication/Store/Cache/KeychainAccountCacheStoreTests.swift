//
//  KeychainAccountCacheStoreTests.swift
//  NawatechGalleryTests
//
//  Created by Reynaldi on 20/08/23.
//

import XCTest

protocol AccountCacheStoreSaver {
    func save(_ accountID: String) throws
}

protocol AccountCacheStoreRetriever {
    func retrieve() throws -> String?
}

final class KeychainAccountCacheStore {
    
    enum Error: Swift.Error {
        case failedToRetrieve
        case failedToSave
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
                
        guard let data = result as? Data else { return nil }
        
        let accountID = String(decoding: data, as: UTF8.self)
        return accountID
    }
}

extension KeychainAccountCacheStore: AccountCacheStoreSaver {
    func save(_ accountID: String) throws {
        let data = Data(accountID.utf8)
        
        do {
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: storeKey,
                kSecValueData: data
            ] as CFDictionary
            
            SecItemDelete(query)
            
            guard SecItemAdd(query, nil) == noErr else { throw Error.failedToSave }
            return
            
        } catch {
            throw error
        }
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
    
    func test_retrieveAccountID_deliversValueOnNonEmptyCache() {
        let anyAccountID = "any-account-id"
        let sut = KeychainAccountCacheStore(storeKey: "keychain.account.store.test.key")
        
        do {
            try sut.save(anyAccountID)
            
            let receivedValue = try sut.retrieve()
            XCTAssertEqual(receivedValue, anyAccountID)
            
        } catch {
            XCTFail("Expected to succeed with value")
        }
    }
}
