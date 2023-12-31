//
//  DetailCatalogueItemViewModel.swift
//  NawatechGallery
//
//  Created by Reynaldi on 22/08/23.
//

import Foundation

public final class DetailCatalogueItemViewModel {
    public let id: UUID
    public let imageURL: URL
    public let title: String
    public let detail: String
    public let price: String
    public let cartButtonEnable: Bool
    public let cartButtonText: String
    
   public init(id: UUID, imageURL: URL, title: String, detail: String, price: String, cartButtonEnable: Bool, cartButtonText: String) {
        self.id = id
        self.imageURL = imageURL
        self.title = title
        self.detail = detail
        self.price = price
        self.cartButtonEnable = cartButtonEnable
        self.cartButtonText = cartButtonText
    }
}
