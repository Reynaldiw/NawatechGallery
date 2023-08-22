//
//  CartUIComposer.swift
//  NawatechGallery
//
//  Created by Reynaldi on 22/08/23.
//

import UIKit
import Combine

public final class CartUIComposer {
    private init() {}
    
    private typealias CartPresentationAdapter = LoadResourcePresentationAdapter<[CartCatalogueItem], CartResourceViewAdapter>
    
    public static func cartComposedWith(
        cartLoader: @escaping () -> AnyPublisher<[CartCatalogueItem], Error>,
        imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>,
        selection: @escaping (CartCatalogueItem) -> Void = { _ in }
    ) -> ListViewController {
        let adapter = CartPresentationAdapter(loader: cartLoader)
        
        let cartController = makeCartViewController(title: CartCatalogueItemPresenter.title)
        
        adapter.presenter = LoadResourcePresenter(
            resourceView: CartResourceViewAdapter(
                controller: cartController,
                imageLoader: imageLoader,
                selection: selection),
            loadingView: WeakRefVirtualProxy(object: cartController),
            errorView: WeakRefVirtualProxy(object: cartController)
        )
        
        return cartController
    }
    
    private static func makeCartViewController(title: String) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "Cart", bundle: bundle)
        let cartController = storyboard.instantiateInitialViewController() as! ListViewController
        cartController.title = title
        
        return cartController
    }
}
