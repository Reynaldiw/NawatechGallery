//
//  AuthenticationUserStore.swift
//  NawatechGallery
//
//  Created by Reynaldi on 18/08/23.
//

import Foundation

public protocol AuthenticationUserStore {
    func retrieve(thatMatchedWith username: String) throws -> [[String: Any]]
}
