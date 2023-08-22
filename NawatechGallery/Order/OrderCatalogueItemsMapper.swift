//
//  OrderCatalogueItemsMapper.swift
//  NawatechGallery
//
//  Created by Reynaldi on 22/08/23.
//

import Foundation

public final class OrderCatalogueItemsMapper {
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data) throws -> [OrderCatalogueItem] {
        guard let storedOrders = try? JSONDecoder().decode([StoredOrderCatalogueItem].self, from: data)
        else { throw Error.invalidData }
        
        return storedOrders.map { $0.model }
    }
}
