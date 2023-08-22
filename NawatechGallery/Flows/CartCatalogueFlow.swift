//
//  CartCatalogueFlow.swift
//  NawatechGallery
//
//  Created by Reynaldi on 22/08/23.
//

import Combine
import Foundation
import FirebaseFirestore

final class CartCatalogueFlow {
    
    private lazy var scheduler: AnyDispatchQueueScheduler = DispatchQueue(
        label: "com.reynaldi.cart.infra.queue",
        qos: .userInitiated,
        attributes: .concurrent
    ).eraseToAnyScheduler()
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var firestoreClient: SharedFirestoreClient = {
        SharedFirestoreClient(
            collectionReference: Firestore.firestore()
                .collection("catalogue")
                .document("motorcycle")
                .collection("items")
        )
    }()
    
    private lazy var accountCacheStore: AccountCacheStoreRetriever = {
        KeychainAccountCacheStore(storeKey: SharedKeys.accountKeychainKey)
    }()
    
    func start() -> ListViewController {
        let cartController = CartUIComposer.cartComposedWith(
            cartLoader: loadCart,
            imageLoader: loadImage)
        
        return cartController
    }
    
    private func loadCart() -> AnyPublisher<[CartCatalogueItem], Error> {
        guard let id = try? accountCacheStore.retrieve(),
              let accountID = UUID(uuidString: id)
        else {
            return Fail(error: NSError(domain: "Error retrieving user account", code: 0))
                .eraseToAnyPublisher()
        }
        
        let orderItemsPublisher: AnyPublisher<[OrderCatalogueItem], Error> = makeOrderStoreClient(with: accountID).retrievePublisher(.all)
                .tryMap(OrderCatalogueItemsMapper.map(_:))
                .eraseToAnyPublisher()
                
        return orderItemsPublisher
            .flatMap { [firestoreClient] orderItems in
                Publishers.MergeMany(
                    orderItems.map { item in
                        firestoreClient.retrievePublisher(.all)
                            .tryMap(MotorycleCatalogueItemsMapper.map(_:))
                            .compactMap { $0.first(where: { $0.id.uuidString == item.catalogueID.uuidString }) }
                            .map { catalogueItem in
                                CartCatalogueItem(
                                    orderID: item.id,
                                    catalogueID: catalogueItem.id,
                                    catalogueImageURL: catalogueItem.imageURL,
                                    name: catalogueItem.name,
                                    price: catalogueItem.price,
                                    quantity: item.quantity)
                            }
                    }
                )
                .collect()
            }
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    private func makeOrderStoreClient(with userID: UUID) -> StoreRetriever {
        SharedFirestoreClient(
            collectionReference: Firestore.firestore()
                .collection("users")
                .document(userID.uuidString)
                .collection("orders")
        )
    }
    
    private func loadImage(from url: URL) -> AnyPublisher<Data, Error> {
        httpClient
            .getPublisher(from: url)
            .tryMap(GalleryImageDataMapper.map)
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
}
