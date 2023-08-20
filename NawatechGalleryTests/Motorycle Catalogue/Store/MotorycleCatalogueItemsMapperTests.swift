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
    
    static func map(_ values: [[String: Any]]) -> [MotorcycleCatalogueItem] {
        return []
    }
}

final class MotorycleCatalogueItemsMapperTests: XCTestCase {
    
    func test_map_deliversNoItemsOnEmptyValues() {
        let result = MotorycleCatalogueItemsMapper.map([])
        
        XCTAssertEqual(result, [])
    }
}
