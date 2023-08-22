//
//  StoreOrderCatalogueSaver.swift
//  NawatechGallery
//
//  Created by Reynaldi on 22/08/23.
//

import Foundation

public final class StoreOrderCatalogueSaver {
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    private let store: StoreSaver
    private let orderID: UUID
    private let quantity: Int
    
    public init(store: StoreSaver, orderID: UUID = UUID(), quantity: Int = 1) {
        self.store = store
        self.orderID = orderID
        self.quantity = quantity
    }
    
    public func save(_ catalogueID: UUID) throws {
        let order = StoredOrderCatalogueItem(id: orderID, catalogueID: catalogueID, quantity: quantity)
        let data = try JSONEncoder().encode(order)
        guard let jsonOrderValue = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw Error.invalidData
        }
        
        try store.save(jsonOrderValue, namedWith: orderID.uuidString)
    }
}
