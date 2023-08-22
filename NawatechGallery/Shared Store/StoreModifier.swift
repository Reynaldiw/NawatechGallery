//
//  StoreModifier.swift
//  NawatechGallery
//
//  Created by Reynaldi on 22/08/23.
//

import Foundation

public protocol StoreModifier {
    func update(_ key: String, with value: Any, in path: String) throws
}
