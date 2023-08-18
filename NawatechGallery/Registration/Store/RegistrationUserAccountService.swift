//
//  RegistrationUserAccountService.swift
//  NawatechGallery
//
//  Created by Reynaldi on 18/08/23.
//

import Foundation

public final class RegistrationUserAccountService {
    
    private let store: RegistrationUserAccountStore
    private let dateCreated: () -> Date
    private let idCreated: () -> UUID
    
    public init(store: RegistrationUserAccountStore, dateCreated: @escaping () -> Date = Date.init, idCreated: @escaping () -> UUID = UUID.init) {
        self.store = store
        self.dateCreated = dateCreated
        self.idCreated = idCreated
    }
    
    public func register(_ user: RegistrationUserAccount) throws {
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
