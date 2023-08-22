//
//  FirestoreUserAccountClient.swift
//  NawatechGallery
//
//  Created by Reynaldi on 21/08/23.
//

import Foundation
import FirebaseFirestore

public final class FirestoreUserAccountClient {
    
    private let store: Firestore
    
    private lazy var collection: CollectionReference = {
        store.collection("users")
    }()
    
    init(store: Firestore = Firestore.firestore()) {
        self.store = store
    }
    
    private struct UnexpectedValuesRepresentation: Swift.Error {}
}

extension FirestoreUserAccountClient: StoreRetriever {
    public func retrieve(_ query: StoreQuery) throws -> Data {
        let group = DispatchGroup()
        let collection = self.collection
        
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

extension FirestoreUserAccountClient: StoreModifier {
    public func update(_ key: String, with value: Any, in path: String) throws {
        let group = DispatchGroup()
        
        var receivedError: Swift.Error?
        
        group.enter()
        store
            .collection("users")
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
