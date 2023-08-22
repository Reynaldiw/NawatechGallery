//
//  DetailCatalogueUIComposer.swift
//  NawatechGallery
//
//  Created by Reynaldi on 22/08/23.
//

import Combine
import UIKit

final class DetailCatalogueUIComposer {
    private init() {}
    
    private typealias DetailCataloguePresentationAdapter = LoadResourcePresentationAdapter<DetailCatalogueItemViewModel, DetailCatalogueResourceViewAdapter>
    
    static func detailComposedWith(
        detailLoader: @escaping () -> AnyPublisher<DetailCatalogueItemViewModel, Error>,
        imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>
    ) -> DetailCatalogueItemViewController {
        let adapter = DetailCataloguePresentationAdapter(loader: detailLoader)
        
        let detailController = makeDetailViewController(title: "Detail")
        detailController.loadDetail = adapter.loadResource
        
        adapter.presenter = LoadResourcePresenter(
            resourceView: DetailCatalogueResourceViewAdapter(
                controller: detailController,
                imageLoader: imageLoader),
            loadingView: WeakRefVirtualProxy(object: detailController),
            errorView: WeakRefVirtualProxy(object: detailController)
        )
                
        return detailController
    }
    
    private static func makeDetailViewController(title: String) -> DetailCatalogueItemViewController {
        let bundle = Bundle(for: DetailCatalogueItemViewController.self)
        let storyboard = UIStoryboard(name: "DetailCatalogue", bundle: bundle)
        let detailController = storyboard.instantiateInitialViewController() as! DetailCatalogueItemViewController
        detailController.title = title
        
        return detailController
    }
}
