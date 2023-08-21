//
//  MotorcycleCatalogueItem.swift
//  NawatechGallery
//
//  Created by Reynaldi on 20/08/23.
//

import Foundation

public struct MotorcycleCatalogueItem: Equatable, Hashable {
    public let id: UUID
    public let imageURL: URL
    public let name: String
    public let detail: String
    public let price: Int
    
    public init(id: UUID, imageURL: URL, name: String, detail: String, price: Int) {
        self.id = id
        self.imageURL = imageURL
        self.name = name
        self.detail = detail
        self.price = price
    }
}
