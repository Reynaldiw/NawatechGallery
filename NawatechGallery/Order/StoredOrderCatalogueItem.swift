//
//  StoredOrderCatalogueItem.swift
//  NawatechGallery
//
//  Created by Reynaldi on 22/08/23.
//

import Foundation

internal struct StoredOrderCatalogueItem: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "order_id"
        case catalogueID = "catalogue_item_id"
        case quantity
    }
    
    internal let id: UUID
    internal let catalogueID: UUID
    internal let quantity: Int
    
    internal var model: OrderCatalogueItem {
        OrderCatalogueItem(id: id, catalogueID: catalogueID, quantity: quantity)
    }
}
