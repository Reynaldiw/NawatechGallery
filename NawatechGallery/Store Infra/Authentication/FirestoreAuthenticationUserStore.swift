//
//  FirestoreAuthenticationUserStore.swift
//  NawatechGallery
//
//  Created by Reynaldi on 20/08/23.
//

import Foundation
import FirebaseFirestore

public final class FirestoreAuthenticationUserStore {
    
    private let firestore: Firestore
    private let queryFieldKey: String
    private let collectionPath: String
    
    public init(firestore: Firestore = Firestore.firestore(), queryFieldKey: String, collectionPath: String = "users") {
        self.firestore = firestore
        self.queryFieldKey = queryFieldKey
        self.collectionPath = collectionPath
    }
    
    public struct UnexpectedValuesRepresentation: Error {}
    
}

extension FirestoreAuthenticationUserStore: AuthenticationUserStore {
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

extension FirestoreAuthenticationUserStore: RegistrationUserAccountStore {
    public func retrieve(thatMathedWithUsername username: String) -> StoredRegistrationUserAccount? {
        guard let values = try? retrieve(thatMatchedWith: username) else { return nil }

        return try? values
            .map { try JSONSerialization.data(withJSONObject: $0) }
            .map { try JSONDecoder().decode(StoredRegistrationUserAccount.self, from: $0) }
            .first
    }
    
    public func insert(_ user: StoredRegistrationUserAccount) throws {
        do {
            let group = DispatchGroup()
            var receivedError: Error?
            guard let value = try JSONSerialization.jsonObject(with: JSONEncoder().encode(user)) as? [String: Any] else { return }

            group.enter()
            firestore
                .collection(collectionPath)
                .document(user.id.uuidString)
                .setData(value, merge: false) { error in
                    if let error = error {
                        receivedError = error
                    }
                    group.leave()
                }
            group.wait()
            
            if let receivedError = receivedError {
                throw receivedError
            }
        } catch {
            throw error
        }
    }
}
