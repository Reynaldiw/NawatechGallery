//
//  DetailCatalogueImageViewAdapter.swift
//  NawatechGallery
//
//  Created by Reynaldi on 22/08/23.
//

import Foundation

final class DetailCatalogueImageViewAdapter: ResourceLoadingView, ResourceErrorView {
    private weak var controller: DetailCatalogueItemViewController?

    init(controller: DetailCatalogueItemViewController) {
        self.controller = controller
    }
    
    func display(_ viewModel: ResourceLoadingViewModel) {
        controller?.displayImageView(viewModel.isLoading)
    }
    
    func display(_ viewModel: ResourceErrorViewModel) {
        guard viewModel.error != nil else { return }
    }
}
