//
//  ProfileAccountStoreRetriever.swift
//  NawatechGallery
//
//  Created by Reynaldi on 21/08/23.
//

import Foundation

public protocol `ProfileAccountStoreRetriever` {
    func retrive(userID: String) throws -> Data
}
