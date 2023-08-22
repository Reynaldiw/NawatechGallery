//
//  FirestoreUserOrderClient.swift
//  NawatechGallery
//
//  Created by Reynaldi on 22/08/23.
//

import Foundation
import FirebaseFirestore

public final class FirestoreUserOrderClient {
    
    private let store: Firestore
    private let userID: UUID
    
    private lazy var collection: CollectionReference = {
        store.collection("users")
            .document(userID.uuidString)
            .collection("orders")
    }()
    
    init(store: Firestore = Firestore.firestore(), userID: UUID) {
        self.store = store
        self.userID = userID
    }
    
    private struct UnexpectedValuesRepresentation: Swift.Error {}
}

extension FirestoreUserOrderClient: StoreRetriever {
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

extension FirestoreUserOrderClient: StoreSaver {
    public func save(_ value: [String : Any], namedWith name: String) throws {
        let group = DispatchGroup()
        var receivedError: Swift.Error?

        group.enter()
        collection.document(name)
            .setData(value, merge: false) { error in
                if let error = error {
                    receivedError = error
                }
                group.leave()
            }
        group.wait()
        
        guard let receivedError = receivedError else { return }
        throw receivedError
    }
}
