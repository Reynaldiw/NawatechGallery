//
//  MotorycleCatalogueItemsMapper.swift
//  NawatechGallery
//
//  Created by Reynaldi on 20/08/23.
//

import Foundation

public final class MotorycleCatalogueItemsMapper {
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
    
    public enum Error: Swift.Error {
        case invalidData
    }
        
    public static func map(_ data: Data) throws -> [MotorcycleCatalogueItem] {
        guard let storedItems = try? JSONDecoder().decode([StoredMotorycleCatalogueItem].self, from: data) else {
            throw Error.invalidData
        }
        
        return storedItems.map { $0.item }
    }
}
