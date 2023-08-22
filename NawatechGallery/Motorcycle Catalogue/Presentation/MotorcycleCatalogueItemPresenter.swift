//
//  MotorcycleCatalogueItemPresenter.swift
//  NawatechGallery
//
//  Created by Reynaldi on 21/08/23.
//

import Foundation

public final class MotorcycleCatalogueItemPresenter {
    public static func convert(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID") // Set the locale to Indonesian for Rupiah
        
        if let formattedString = formatter.string(from: NSNumber(value: price)) {
            return formattedString
        } else {
            return "Rp\(price)"
        }
    }
    
    public static func map(_ model: MotorcycleCatalogueItem) -> CatalogueItemViewModel {
        CatalogueItemViewModel(title: model.name)
    }
}
