//
//  CartCatalogueItem.swift
//  NawatechGallery
//
//  Created by Reynaldi on 22/08/23.
//

import Foundation

public struct CartCatalogueItem: Equatable {
    public let orderID: UUID
    public let catalogueID: UUID
    public let catalogueImageURL: URL
    public let name: String
    public let price: Int
    public let quantity: Int
    
    public init(orderID: UUID, catalogueID: UUID, catalogueImageURL: URL, name: String, price: Int, quantity: Int) {
        self.orderID = orderID
        self.catalogueID = catalogueID
        self.catalogueImageURL = catalogueImageURL
        self.name = name
        self.price = price
        self.quantity = quantity
    }
}
