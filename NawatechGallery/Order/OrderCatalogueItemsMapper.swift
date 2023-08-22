//
//  OrderCatalogueItemsMapper.swift
//  NawatechGallery
//
//  Created by Reynaldi on 22/08/23.
//

import Foundation

public final class OrderCatalogueItemsMapper {
    
    private struct StoredOrderCatalogueItem: Decodable {
        enum CodingKeys: String, CodingKey {
            case id = "order_id"
            case catalogueID = "catalogue_item_id"
            case quantity
        }
        
        let id: UUID
        let catalogueID: UUID
        let quantity: Int
        
        var model: OrderCatalogueItem {
            OrderCatalogueItem(id: id, catalogueID: catalogueID, quantity: quantity)
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data) throws -> [OrderCatalogueItem] {
        guard let storedOrders = try? JSONDecoder().decode([StoredOrderCatalogueItem].self, from: data)
        else { throw Error.invalidData }
        
        return storedOrders.map { $0.model }
    }
}
