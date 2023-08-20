//
//  KeychainAccountCacheStoreTests.swift
//  NawatechGalleryTests
//
//  Created by Reynaldi on 20/08/23.
//

import XCTest
import NawatechGallery

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
