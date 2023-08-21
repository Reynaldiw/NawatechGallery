//
//  FirestoreMotorycleCatalogueStore.swift
//  NawatechGallery
//
//  Created by Reynaldi on 21/08/23.
//

import Foundation
import FirebaseFirestore

public final class FirestoreMotorycleCatalogueStore {
    
    private let firestore: Firestore
    
    public init(firestore: Firestore = Firestore.firestore()) {
        self.firestore = firestore
    }
    
    public struct UnexpectedValuesRepresentation: Error {}
}

extension FirestoreMotorycleCatalogueStore: MotorycleCatalogueStore {
    public func retrieve() throws -> Data {
        let group = DispatchGroup()
        var receivedError: Error?
        var values: [[String: Any]] = []
        
        group.enter()
        firestore
            .collection("catalogue")
            .document("motorcycle")
            .collection("items")
            .getDocuments { snapshot, error in
                if let error = error  {
                    receivedError = error
                } else if let snapshot = snapshot {
                    values = snapshot.documents.map { $0.data() }
                } else {
                    receivedError = UnexpectedValuesRepresentation()
                }
                group.leave()
            }
        group.wait()
        
        do {
            if let receivedError = receivedError {
                throw receivedError
            }
            
            return try JSONSerialization.data(withJSONObject: values)
        } catch {
            throw error
        }
    }
}
