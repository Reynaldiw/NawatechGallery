//
//  MotorcycleCatalogueFlow.swift
//  NawatechGallery
//
//  Created by Reynaldi on 21/08/23.
//

import Foundation
import Combine

final class MotorcycleCatalogueFlow {
    
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
    
    func start() -> ListViewController {
        return CatalogueUIComposer.catalogueComposedWith(
            catalogueLoader: loadCatalogue,
            imageLoader: loadImage(from:))
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
}
