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
    private typealias AddToCardPresentationAdapter = SendResourcePresentationAdapter<UUID>
    
    private weak var controller: DetailCatalogueItemViewController?
    private let orderSaver: (UUID) -> AnyPublisher<Void, Error>
    private let imageLoader: (URL) -> AnyPublisher<Data, Error>
    
    init(
        controller: DetailCatalogueItemViewController,
        orderSaver: @escaping (UUID) -> AnyPublisher<Void, Error>,
        imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>
    ) {
        self.controller = controller
        self.orderSaver = orderSaver
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: DetailCatalogueItemViewModel) {
        guard let controller = controller else { return }
        
        let imageAdapter = ImageDataPresentationAdapter(loader: { [imageLoader] in
            imageLoader(viewModel.imageURL)
        })
        let addToCartAdapter = AddToCardPresentationAdapter(sender: orderSaver)
        
        controller.delegate = imageAdapter
        controller.addToCart = { addToCartAdapter.send(viewModel.id) }
        
        let view = DetailCatalogueImageViewAdapter(controller: controller)
        imageAdapter.presenter = LoadResourcePresenter(
            resourceView: WeakRefVirtualProxy(object: controller),
            loadingView: view,
            errorView: view,
            mapper: UIImage.tryMake)
        
        addToCartAdapter.presenter = SendResourcePresenter(
            succeedView: WeakRefVirtualProxy(object: controller),
            loadingView: WeakRefVirtualProxy(object: controller),
            errorView: WeakRefVirtualProxy(object: controller))
        
        controller.display(viewModel)
    }
}
