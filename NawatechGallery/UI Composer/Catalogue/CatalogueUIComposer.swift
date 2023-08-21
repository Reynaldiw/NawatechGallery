//
//  CatalogueUIComposer.swift
//  NawatechGallery
//
//  Created by Reynaldi on 21/08/23.
//

import Combine
import UIKit

public final class CatalogueUIComposer {
    private init() {}
    
    private typealias CataloguePresentationAdapter = LoadResourcePresentationAdapter<[MotorcycleCatalogueItem], CatalogueViewAdapter>
    
    public static func catalogueComposedWith(
        catalogueLoader: @escaping () -> AnyPublisher<[MotorcycleCatalogueItem], Error>,
        imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>,
        selection: @escaping (MotorcycleCatalogueItem) -> Void = { _ in }
    ) -> ListViewController {
        let presentationAdapter = CataloguePresentationAdapter(loader: catalogueLoader)
        
        let catalogueController = makeCatalogueViewController(title: CataloguePresenter.title)
        catalogueController.onRefresh = presentationAdapter.loadResource
        
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: CatalogueViewAdapter(
                controller: catalogueController,
                imageLoader: imageLoader,
                selection: selection),
            loadingView: WeakRefVirtualProxy(object: catalogueController),
            errorView: WeakRefVirtualProxy(object: catalogueController))
        
        return catalogueController
    }
    
    private static func makeCatalogueViewController(title: String) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "Catalogue", bundle: bundle)
        let catalogueController = storyboard.instantiateInitialViewController() as! ListViewController
        catalogueController.title = title
        
        return catalogueController
    }
}
