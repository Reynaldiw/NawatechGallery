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
