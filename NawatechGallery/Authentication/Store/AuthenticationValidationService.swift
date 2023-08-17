//
//  AuthenticationValidationService.swift
//  NawatechGallery
//
//  Created by Reynaldi on 18/08/23.
//

import Foundation

public final class AuthenticationValidationService {
    
    private let store: AuthenticationUserStore
    
    public init(store: AuthenticationUserStore) {
        self.store = store
    }
    
    public enum Error: Swift.Error {
        case notFound
        case passwordNotMatched
    }
    
    public func validate(_ user: AuthenticationUserBody) throws -> UserAccount {
        do {
            let receivedUsers = try store.retrieve(thatMatchedWith: user.username)
            guard !receivedUsers.isEmpty else {
                throw Error.notFound
            }
            
            let matchedStoredUser = try receivedUsers
                .map { try JSONSerialization.data(withJSONObject: $0) }
                .map { try JSONDecoder().decode(StoredUserAccount.self, from: $0) }
                .first(where: { $0.password == user.password })
            
            guard let matchedStoredUser = matchedStoredUser else {
                throw Error.passwordNotMatched
            }
            
            return matchedStoredUser.userAccount
            
        } catch {
            throw error
        }
    }
}
