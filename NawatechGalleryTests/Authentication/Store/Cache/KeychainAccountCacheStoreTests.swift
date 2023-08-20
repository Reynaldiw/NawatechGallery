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
        case failedToDelete
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

extension KeychainAccountCacheStore {
    func delete() throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: storeKey
        ] as CFDictionary
        
        guard SecItemDelete(query) == noErr else { throw Error.failedToDelete }
    }
}

final class KeychainAccountCacheStoreTests: XCTestCase {
    
    func test_retrieveAccountID_deliversEmptyValueOnEmptyCache() {
        expectSUT(toRetrive: nil)
    }
    
    func test_retrieveAccountID_deliversValueOnNonEmptyCache() {
        let anyAccountID = "any-account-id"
        
        save(anyAccountID)

        expectSUT(toRetrive: anyAccountID)
    }
    
    func test_retrieveAccountID_deliversLastSavedValue() {
        let anyAccountID1 = "any-account-id-1"
        let anyAccountID2 = "any-account-id-2"

        save(anyAccountID1)
        save(anyAccountID2)
        
        expectSUT(toRetrive: anyAccountID2)
    }
    
    //MARK: - Helpers
    
    private func makeSUT(storeKey: String = "keychain.account.store.test.key") -> KeychainAccountCacheStore {
        let sut = KeychainAccountCacheStore(storeKey: storeKey)
        
        addTeardownBlock {
            try? KeychainAccountCacheStore(storeKey: storeKey).delete()
        }
        
        return sut
    }
    
    private func expectSUT(toRetrive expectedValue: String?, file: StaticString = #file, line: UInt = #line) {
        do {
            let receivedValue = try makeSUT().retrieve()
            XCTAssertEqual(receivedValue, expectedValue, file: file, line: line)
            
        } catch {
            XCTFail("Expected to succeed with value \(String(describing: expectedValue)), but got error \(error) instead", file: file, line: line)
        }
    }
    
    private func save(_ accountID: String) {
        try? makeSUT().save(accountID)
    }
}
