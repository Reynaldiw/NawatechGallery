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
    
    init(store: Firestore = Firestore.firestore()) {
        self.store = store
    }
    
    private struct UnexpectedValuesRepresentation: Swift.Error {}
}

extension FirestoreUserAccountClient: UserAccountStoreRetriever {
    public func retrieve(_ query: UserAccountQuery) throws -> [Data] {
        let group = DispatchGroup()
        
        let collection: Query = store.collection("users")
        switch query {
        case .matched(let (value, key)):
            collection.whereField(key, isEqualTo: value)
        default: break
        }
        
        var result: ((snapshot: QuerySnapshot?, error: Error?))?
        
        group.enter()
        collection.getDocuments { snapshot, error in
            result = (snapshot, error)
            group.leave()
        }
        group.wait()
        
        guard let result = result else { return [] }
        
        return try extract(snapshot: result.snapshot, error: result.error)
    }
    
    private func extract(snapshot: QuerySnapshot?, error: Error?) throws -> [Data] {
        if let error = error {
            throw error
        } else if let snapshot = snapshot {
            return try snapshot.documents
                .map { $0.data() }
                .map { try JSONSerialization.data(withJSONObject: $0) }
        } else {
            throw UnexpectedValuesRepresentation()
        }
    }
}
