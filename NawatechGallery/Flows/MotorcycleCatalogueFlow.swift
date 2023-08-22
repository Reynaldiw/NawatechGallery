//
//  MotorcycleCatalogueFlow.swift
//  NawatechGallery
//
//  Created by Reynaldi on 21/08/23.
//

import Foundation
import Combine

final class MotorcycleCatalogueFlow {
    
    private var listCatalogueController: ListViewController?
    
    private lazy var scheduler: AnyDispatchQueueScheduler = DispatchQueue(
        label: "com.reynaldi.catalogue.infra.queue",
        qos: .userInitiated,
        attributes: .concurrent
    ).eraseToAnyScheduler()
    
    private lazy var catalogueStore: MotorycleCatalogueStore = {
        FirestoreMotorycleCatalogueStore()
    }()
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var accountCacheStore: AccountCacheStoreRetriever = {
        KeychainAccountCacheStore(storeKey: SharedKeys.accountKeychainKey)
    }()
    
    func start() -> ListViewController {
        listCatalogueController = CatalogueUIComposer.catalogueComposedWith(
            catalogueLoader: loadCatalogue,
            imageLoader: loadImage(from:),
            selection: showDetailCatalogueItem(_:))
            
        return listCatalogueController!
    }
    
    private func showDetailCatalogueItem(_ item: MotorcycleCatalogueItem) {
        let detailCatalogue = DetailCatalogueUIComposer.detailComposedWith(
            detailLoader: { [loadDetail] in
                loadDetail(item)
            },
            imageLoader: loadImage(from:))
        
        listCatalogueController?.show(detailCatalogue, sender: self)
    }
    
    private func loadCatalogue() -> AnyPublisher<[MotorcycleCatalogueItem], Error> {
        catalogueStore
            .retrievePublisher()
            .tryMap(MotorycleCatalogueItemsMapper.map)
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    private func loadImage(from url: URL) -> AnyPublisher<Data, Error> {
        httpClient
            .getPublisher(from: url)
            .tryMap(GalleryImageDataMapper.map)
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    private func loadDetail(_ item: MotorcycleCatalogueItem) -> AnyPublisher<DetailCatalogueItemViewModel, Error> {
        guard let idString = try? accountCacheStore.retrieve(),
              let id = UUID(uuidString: idString)
        else {
            return Fail(error: NSError(domain: "Error retrieving user ID", code: 0))
                .eraseToAnyPublisher()
        }
        
        return makeOrderStoreClient(with: id)
            .retrievePublisher(.matched((item.id.uuidString, "catalogue_item_id")))
            .tryMap(OrderCatalogueItemsMapper.map)
            .map { orders in
                DetailCatalogueItemViewModel(
                    imageURL: item.imageURL,
                    title: item.name,
                    detail: item.detail,
                    price: MotorcycleCatalogueItemPresenter.convert(item.price),
                    cartButtonEnable: orders.isEmpty,
                    cartButtonText: DetailCatalogueItemPresenter.cartButtonText(orders.isEmpty))
            }
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    private func makeOrderStoreClient(with userID: UUID) -> StoreRetriever {
        FirestoreUserOrderClient(userID: userID)
    }
}
