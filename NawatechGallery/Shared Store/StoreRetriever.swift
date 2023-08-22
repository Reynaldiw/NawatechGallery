//
//  StoreRetriever.swift
//  NawatechGallery
//
//  Created by Reynaldi on 21/08/23.
//

import Foundation

public protocol StoreRetriever {
    func retrieve(_ query: StoreQuery) throws -> Data
}
