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
        
        var item: MotorcycleCatalogueItem {
            MotorcycleCatalogueItem(id: id, imageURL: imageURL, name: name, detail: detail, price: price)
        }
    }
    
    enum Error: Swift.Error {
        case invalidData
    }
        
    static func map(_ data: Data) throws -> [MotorcycleCatalogueItem] {
        guard let storedItems = try? JSONDecoder().decode([StoredMotorycleCatalogueItem].self, from: data) else {
            throw Error.invalidData
        }
        
        return storedItems.map { $0.item }
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
    
    func test_map_deliversItemsOnNonEmptyValues() throws {
        let item1 = makeItem(
            id: UUID(),
            image: URL(string: "https://a-url.com")!,
            name: "a name",
            detail: "a detail",
            price: 100000)
        
        let item2 = makeItem(
            id: UUID(),
            image: URL(string: "https://another-url.com")!,
            name: "another name",
            detail: "another detail",
            price: 50000)

        let values = makeItemValues([item1.value, item2.value])
        
        let result = try MotorycleCatalogueItemsMapper.map(values)
        
        XCTAssertEqual(result, [item1.model, item2.model])
    }
    
    //MARK: - Helpers
    
    private func makeItem(id: UUID, image: URL, name: String, detail: String, price: Int) -> (model: MotorcycleCatalogueItem, value: [String: Any]) {
        let model = MotorcycleCatalogueItem(id: id, imageURL: image, name: name, detail: detail, price: price)
        let value: [String: Any] = [
            "id": id.uuidString,
            "image_url": image.absoluteString,
            "name": name,
            "detail": detail,
            "price": price
        ]
        
        return (model, value)
    }
    
    private func makeItemValues(_ items: [[String: Any]]) -> Data {
        return try! JSONSerialization.data(withJSONObject: items)
    }
}
