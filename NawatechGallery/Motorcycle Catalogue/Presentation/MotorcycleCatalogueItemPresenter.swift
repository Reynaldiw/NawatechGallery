//
//  MotorcycleCatalogueItemPresenter.swift
//  NawatechGallery
//
//  Created by Reynaldi on 21/08/23.
//

import Foundation

public final class MotorcycleCatalogueItemPresenter {
    public static func map(_ model: MotorcycleCatalogueItem) -> CatalogueItemViewModel {
        CatalogueItemViewModel(title: model.name)
    }
}
