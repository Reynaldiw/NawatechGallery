//
//  OrderCatalogueItem.swift
//  NawatechGallery
//
//  Created by Reynaldi on 22/08/23.
//

import Foundation

public struct OrderCatalogueItem: Equatable {
    public let id: UUID
    public let catalogueID: UUID
    public let quantity: Int
    
    public init(id: UUID, catalogueID: UUID, quantity: Int) {
        self.id = id
        self.catalogueID = catalogueID
        self.quantity = quantity
    }
}
