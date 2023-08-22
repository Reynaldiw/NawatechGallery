//
//  DetailCatalogueResourceViewAdapter.swift
//  NawatechGallery
//
//  Created by Reynaldi on 22/08/23.
//

import Combine
import UIKit

final class DetailCatalogueResourceViewAdapter: ResourceView {
    
    typealias ResourceViewModel = DetailCatalogueItemViewModel
    private typealias ImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, WeakRefVirtualProxy<DetailCatalogueItemViewController>>
    
    private weak var controller: DetailCatalogueItemViewController?
    private let imageLoader: (URL) -> AnyPublisher<Data, Error>
    
    init(controller: DetailCatalogueItemViewController, imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: DetailCatalogueItemViewModel) {
        guard let controller = controller else { return }
        
        let adapter = ImageDataPresentationAdapter(loader: { [imageLoader] in
            imageLoader(viewModel.imageURL)
        })
        controller.delegate = adapter
        
        let view = DetailCatalogueImageViewAdapter(controller: controller)
        
        adapter.presenter = LoadResourcePresenter(
            resourceView: WeakRefVirtualProxy(object: controller),
            loadingView: view,
            errorView: view,
            mapper: UIImage.tryMake)
        
        controller.display(viewModel)
    }
}
