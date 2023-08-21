//
//  UserAccountStoreReplacer.swift
//  NawatechGallery
//
//  Created by Reynaldi on 22/08/23.
//

import Foundation

public protocol UserAccountStoreReplacer {
    func update(_ key: String, with value: Any, in path: String) throws
}
