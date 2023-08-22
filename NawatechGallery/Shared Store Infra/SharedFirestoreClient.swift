//
//  SharedFirestoreClient.swift
//  NawatechGallery
//
//  Created by Reynaldi on 22/08/23.
//

import Foundation
import FirebaseFirestore

public final class SharedFirestoreClient {
    
    private struct UnexpectedValuesRepresentation: Swift.Error {}
    
    private let collectionReference: CollectionReference
    
    public init(collectionReference: CollectionReference) {
        self.collectionReference = collectionReference
    }
}

extension SharedFirestoreClient: StoreRetriever {
    
    public func retrieve(_ query: StoreQuery) throws -> Data {
        let group = DispatchGroup()
        var result: Result<[[String: Any]], Error>!
        
        switch query {
        case let .matched((value, key)):
            group.enter()
            collectionReference
                .whereField(key, isEqualTo: value)
                .getDocuments { snapshot, error in
                    result = Result(catching: {
                        try snapshot?.documents.map { $0.data() } ?? { throw error ?? UnexpectedValuesRepresentation() }()
                    })
                    group.leave()
                }
        default:
            group.enter()
            collectionReference
                .getDocuments { snapshot, error in
                    result = Result(catching: {
                        try snapshot?.documents.map { $0.data() } ?? { throw error ?? UnexpectedValuesRepresentation() }()
                        
                    })
                    group.leave()
                }
        }
        group.wait()
        
        return try JSONSerialization.data(withJSONObject: result.get())
    }
}

extension SharedFirestoreClient: StoreModifier {
    public func update(_ key: String, with value: Any, in path: String) throws {
        let group = DispatchGroup()
        
        var receivedError: Swift.Error?
        
        group.enter()
        collectionReference
            .document(path)
            .updateData([key: value]) { error in
                receivedError = error
                group.leave()
            }
        group.wait()
        
        guard let receivedError = receivedError else { return }
        throw receivedError
    }
}

extension SharedFirestoreClient: StoreSaver {
    public func save(_ value: [String : Any], namedWith name: String) throws {
        let group = DispatchGroup()
        
        var receivedError: Swift.Error?
        
        group.enter()
        collectionReference
            .document(name)
            .setData(value) { error in
                receivedError = error
                group.leave()
            }
        group.wait()
        
        guard let receivedError = receivedError else { return }
        throw receivedError
    }
}
