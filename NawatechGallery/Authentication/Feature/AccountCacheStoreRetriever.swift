//
//  AccountCacheStoreRetriever.swift
//  NawatechGallery
//
//  Created by Reynaldi on 20/08/23.
//

import Foundation

public protocol AccountCacheStoreRetriever {
    func retrieve() throws -> String?
}
