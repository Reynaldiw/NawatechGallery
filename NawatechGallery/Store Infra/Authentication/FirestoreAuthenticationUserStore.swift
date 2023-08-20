//
//  FirestoreAuthenticationUserStore.swift
//  NawatechGallery
//
//  Created by Reynaldi on 20/08/23.
//

import Foundation
import FirebaseFirestore

public final class FirestoreAuthenticationUserStore: AuthenticationUserStore {
    
    private let firestore: Firestore
    private let queryFieldKey: String
    private let collectionPath: String
    
    public init(firestore: Firestore = Firestore.firestore(), queryFieldKey: String, collectionPath: String = "users") {
        self.firestore = firestore
        self.queryFieldKey = queryFieldKey
        self.collectionPath = collectionPath
    }
    
    public struct UnexpectedValuesRepresentation: Error {}
    
    public func retrieve(thatMatchedWith username: String) throws -> [[String : Any]] {
        let group = DispatchGroup()
        var receivedError: Error?
        var values: [[String: Any]] = []
        
        group.enter()
        firestore.collection(collectionPath)
            .whereField(queryFieldKey, isEqualTo: username)
            .getDocuments { snapshot, error in
                if let error = error {
                    receivedError = error
                } else if let snapshot = snapshot {
                    values = snapshot.documents.map { $0.data() }
                } else {
                    receivedError = UnexpectedValuesRepresentation()
                }
                group.leave()
            }
        group.wait()
        
        if let receivedError = receivedError {
            throw receivedError
        }
        
        return values
    }
}
