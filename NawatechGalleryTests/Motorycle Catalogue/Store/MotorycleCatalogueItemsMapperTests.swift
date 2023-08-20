//
//  MotorycleCatalogueItemsMapperTests.swift
//  NawatechGalleryTests
//
//  Created by Reynaldi on 20/08/23.
//

import XCTest
import NawatechGallery

final class MotorycleCatalogueItemsMapper {
    private struct StoredMotorycleCatalogueItem: Decodable {
        
        private enum CodingKeys: String, CodingKey {
            case id, name, detail, price
            case imageURL = "image_url"
        }
        
        let id: UUID
        let imageURL: URL
        let name: String
        let detail: String
        let price: Int
    }
    
    enum Error: Swift.Error {
        case invalidData
    }
        
    static func map(_ data: Data) throws -> [MotorcycleCatalogueItem] {
        guard let _ = try? JSONDecoder().decode([StoredMotorycleCatalogueItem].self, from: data) else {
            throw Error.invalidData
        }
        
        return []
    }
}

final class MotorycleCatalogueItemsMapperTests: XCTestCase {
    
    func test_map_deliversErrorOnInvalidData() throws {
        let invalidData = Data("Invalid values".utf8)
        
        XCTAssertThrowsError(
            try MotorycleCatalogueItemsMapper.map(invalidData)
        )
    }
    
    func test_map_deliversNoItemsOnEmptyValues() throws {
        let result = try MotorycleCatalogueItemsMapper.map(makeItemValues([]))
        
        XCTAssertEqual(result, [])
    }
    
    //MARK: - Helpers
    
    private func makeItemValues(_ items: [[String: Any]]) -> Data {
        return try! JSONSerialization.data(withJSONObject: items)
    }
}
