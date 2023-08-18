//
//  RegistrationUserAccountStore.swift
//  NawatechGallery
//
//  Created by Reynaldi on 18/08/23.
//

import Foundation

public protocol RegistrationUserAccountStore {
    func insert(_ user: StoredRegistrationUserAccount) throws
}
