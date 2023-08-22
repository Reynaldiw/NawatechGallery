//
//  CartResourceView.swift
//  NawatechGallery
//
//  Created by Reynaldi on 22/08/23.
//

import UIKit
import Combine

public final class CartResourceViewAdapter: ResourceView {
    
    public typealias ResourceViewModel = [CartCatalogueItem]
    
    private typealias ImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, WeakRefVirtualProxy<CartCatalogueItemCellController>>
    
    private weak var controller: ListViewController?
    private let imageLoader: (URL) -> AnyPublisher<Data, Error>
    private let selection: (CartCatalogueItem) -> Void
    
    init(controller: ListViewController, imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>, selection: @escaping (CartCatalogueItem) -> Void) {
        self.controller = controller
        self.imageLoader = imageLoader
        self.selection = selection
    }
    
    public func display(_ viewModel: [CartCatalogueItem]) {
        controller?.display(
            viewModel.map { model in
                let adapter = ImageDataPresentationAdapter(loader: { [imageLoader] in
                    imageLoader(model.catalogueImageURL)
                })
                
                let view = CartCatalogueItemCellController(
                    viewModel: CartCatalogueItemPresenter.map(model),
                    delegate: adapter,
                    selection: { [selection] in
                        selection(model)
                    })
                
                adapter.presenter = LoadResourcePresenter(
                    resourceView: WeakRefVirtualProxy(object: view),
                    loadingView: WeakRefVirtualProxy(object: view),
                    errorView: WeakRefVirtualProxy(object: view),
                    mapper: UIImage.tryMake)
                
                let controller = CellController(id: model, dataSource: view)
                return controller
            }
        )
    }
}
