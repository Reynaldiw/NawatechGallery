//
//  MotorycleCatalogueItemsMapperTests.swift
//  NawatechGalleryTests
//
//  Created by Reynaldi on 20/08/23.
//

import XCTest
import NawatechGallery

final class MotorycleCatalogueItemsMapper {
    private init() {}
    
    static func map(_ data: Data) -> [MotorcycleCatalogueItem] {
        return []
    }
}

final class MotorycleCatalogueItemsMapperTests: XCTestCase {
    
    func test_map_deliversNoItemsOnEmptyValues() {
        let result = MotorycleCatalogueItemsMapper.map(makeItemValues([]))
        
        XCTAssertEqual(result, [])
    }
    
    //MARK: - Helpers
    
    private func makeItemValues(_ items: [[String: Any]]) -> Data {
        return try! JSONSerialization.data(withJSONObject: items)
    }
}
