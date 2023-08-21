//
//  UserAccountStoreRetriever.swift
//  NawatechGallery
//
//  Created by Reynaldi on 21/08/23.
//

import Foundation

public protocol UserAccountStoreRetriever {
    func retrieve(_ query: UserAccountQuery) throws -> [Data]
}
