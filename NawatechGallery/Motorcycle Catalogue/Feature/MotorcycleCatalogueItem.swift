//
//  MotorcycleCatalogueItem.swift
//  NawatechGallery
//
//  Created by Reynaldi on 20/08/23.
//

import Foundation

public struct MotorcycleCatalogueItem: Equatable {
    public let id: UUID
    public let imageURL: URL
    public let name: String
    public let detail: String
    public let price: Int
}
