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
    private let userID: String
    
    init(store: Firestore, userID: String) {
        self.store = store
        self.userID = userID
    }
    
    private struct UnexpectedValuesRepresentation: Swift.Error {}
}

extension FirestoreUserOrderClient: StoreRetriever {
    public func retrieve(_ query: StoreQuery) throws -> Data {
        let group = DispatchGroup()
        
        let collection: Query = store
            .collection("users")
            .document(userID)
            .collection("orders")
        
        switch query {
        case .matched(let (value, key)):
            collection.whereField(key, isEqualTo: value)
        default: break
        }
        
        var result: ((snapshot: QuerySnapshot?, error: Error?))!
        
        group.enter()
        collection.getDocuments { snapshot, error in
            result = (snapshot, error)
            group.leave()
        }
        group.wait()
                
        return try extract(snapshot: result.snapshot, error: result.error)
    }
    
    private func extract(snapshot: QuerySnapshot?, error: Error?) throws -> Data {
        if let error = error {
            throw error
        } else if let snapshot = snapshot {
            do {
                return try JSONSerialization.data(
                    withJSONObject: snapshot.documents.map { $0.data() })
            } catch {
                throw error
            }
        } else {
            throw UnexpectedValuesRepresentation()
        }
    }
}
