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
    
    private lazy var collection: CollectionReference = {
        firestore
            .collection("catalogue")
            .document("motorcycle")
            .collection("items")
    }()
    
    public init(firestore: Firestore = Firestore.firestore()) {
        self.firestore = firestore
    }
    
    public struct UnexpectedValuesRepresentation: Error {}
}

extension FirestoreMotorycleCatalogueStore: MotorycleCatalogueStore {
    public func retrieve() throws -> Data {
        let group = DispatchGroup()
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
