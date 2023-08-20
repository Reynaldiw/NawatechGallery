//
//  KeychainAccountCacheStore.swift
//  NawatechGallery
//
//  Created by Reynaldi on 20/08/23.
//

import Foundation

public final class KeychainAccountCacheStore {
    
    public enum Error: Swift.Error {
        case failedToRetrieve
        case failedToSave
        case failedToDelete
    }
    
    private let storeKey: String
    
    public init(storeKey: String) {
        self.storeKey = storeKey
    }
}

extension KeychainAccountCacheStore: AccountCacheStoreRetriever {
    public func retrieve() throws -> String? {
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
    public func save(_ accountID: String) throws {
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

extension KeychainAccountCacheStore: AccountCacheStoreRemover {
    public func delete() throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: storeKey
        ] as CFDictionary
        
        guard SecItemDelete(query) == noErr else { throw Error.failedToDelete }
    }
}
