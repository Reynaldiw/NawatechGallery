//
//  AccountCacheStoreSaver.swift
//  NawatechGallery
//
//  Created by Reynaldi on 20/08/23.
//

import Foundation

public protocol AccountCacheStoreSaver {
    func save(_ accountID: String) throws
}
