//
//  DetailCatalogueItemPresenter.swift
//  NawatechGallery
//
//  Created by Reynaldi on 22/08/23.
//

import Foundation

public final class DetailCatalogueItemPresenter {
    
    public static func cartButtonText(_ isOrdersEmpty: Bool) -> String {
        return isOrdersEmpty ? "Add to cart" : "Already added to cart"
    }

}
