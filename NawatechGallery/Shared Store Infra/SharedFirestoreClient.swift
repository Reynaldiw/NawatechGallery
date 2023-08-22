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
        let collection = self.collectionReference
        
        if case let .matched((value, key)) = query {
            collection.whereField(key, isEqualTo: value)
        }
        
        var result: Result<[[String: Any]], Error>!
        
        group.enter()
        collection.getDocuments { snapshot, error in
            result = Result(catching: {
                try snapshot?.documents.map { $0.data() } ?? { throw error ?? UnexpectedValuesRepresentation() }()
                
            })
            group.leave()
        }
        group.wait()
        
        return try JSONSerialization.data(withJSONObject: result.get())
    }
}
