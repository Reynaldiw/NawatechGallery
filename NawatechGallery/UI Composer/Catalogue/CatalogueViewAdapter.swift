//
//  CatalogueViewAdapter.swift
//  NawatechGallery
//
//  Created by Reynaldi on 21/08/23.
//

import UIKit
import Combine

final class CatalogueViewAdapter: ResourceView {
    
    private weak var controller: ListViewController?
    private let imageLoader: (URL) -> AnyPublisher<Data, Error>
    private let selection: (MotorcycleCatalogueItem) -> Void
    
    private typealias ImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, WeakRefVirtualProxy<CatalogueItemCellController>>
    
    init(controller: ListViewController?, imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>, selection: @escaping (MotorcycleCatalogueItem) -> Void) {
        self.controller = controller
        self.imageLoader = imageLoader
        self.selection = selection
    }
    
    func display(_ viewModel: [MotorcycleCatalogueItem]) {
        controller?.display(
            viewModel.map { model in
                let adapter = ImageDataPresentationAdapter(loader: { [imageLoader] in
                    imageLoader(model.imageURL)
                })
                
                let view = CatalogueItemCellController(
                    viewModel: MotorcycleCatalogueItemPresenter.map(model),
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

extension UIImage {
    struct InvalidImageData: Swift.Error {}
    
    static func tryMake(data: Data) throws -> UIImage {
        guard let image = UIImage.init(data: data) else {
            throw InvalidImageData()
        }
        
        return image
    }
}
