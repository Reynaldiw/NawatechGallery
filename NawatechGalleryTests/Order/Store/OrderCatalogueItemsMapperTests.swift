//
//  OrderCatalogueItemsMapperTests.swift
//  NawatechGalleryTests
//
//  Created by Reynaldi on 22/08/23.
//

import XCTest
import NawatechGallery

final class OrderCatalogueItemsMapperTests: XCTestCase {
    func test_map_deliversErrorOnInvalidData() throws {
        let invalidData = Data("Invalid values".utf8)
        
        XCTAssertThrowsError(
            try OrderCatalogueItemsMapper.map(invalidData)
        )
    }
    
    func test_map_deliversNoItemsOnEmptyValues() throws {
        let result = try OrderCatalogueItemsMapper.map(makeItemValues([]))
        
        XCTAssertEqual(result, [])
    }
    
    func test_map_deliversItemsOnNonEmptyValues() throws {
        let item1 = makeItem(orderID: UUID(), catalogueItemID: UUID(), quantity: 1)
        let item2 = makeItem(orderID: UUID(), catalogueItemID: UUID(), quantity: 5)
        let values = makeItemValues([item1.value, item2.value])
        
        let result = try OrderCatalogueItemsMapper.map(values)
        
        XCTAssertEqual(result, [item1.model, item2.model])
    }
    
    //MARK: - Helpers
    
    private func makeItem(orderID: UUID, catalogueItemID: UUID, quantity: Int) -> (model: OrderCatalogueItem, value: [String: Any]) {
        let model = OrderCatalogueItem(id: orderID, catalogueID: catalogueItemID, quantity: quantity)
        let value: [String: Any] = [
            "order_id": orderID.uuidString,
            "catalogue_item_id": catalogueItemID.uuidString,
            "quantity": quantity
        ]
        
        return (model, value)
    }
    
    private func makeItemValues(_ items: [[String: Any]]) -> Data {
        return try! JSONSerialization.data(withJSONObject: items)
    }
}
