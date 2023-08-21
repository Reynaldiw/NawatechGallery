//
//  FirebaseStorageProfileImageStore.swift
//  NawatechGallery
//
//  Created by Reynaldi on 22/08/23.
//

import Foundation
import FirebaseStorage

public final class FirebaseStorageProfileImageStore {
    
    private let storage: StorageReference
    
    public init(
        storage: StorageReference = Storage.storage().reference().child("users/profile/images")
    ) {
        self.storage = storage
    }
    
    private struct UnexpectedValuesRepresentation: Swift.Error {}
}

extension FirebaseStorageProfileImageStore: ProfileImageStore {
    public func upload(_ data: Data, named name: String) throws -> URL {
        let group = DispatchGroup()
        let profileStorage = storage.child("\(name).png")
        
        var receivedError: Swift.Error?
        
        group.enter()
        profileStorage.putData(data) { _, error in
            if let error = error {
                receivedError = error
            }
            group.leave()
        }
        group.wait()
        
        if let receivedError = receivedError {
            throw receivedError
        }
        
        return try downloadURL(with: profileStorage)
    }
    
    private func downloadURL(with storage: StorageReference?) throws -> URL {
        let storage = storage ?? self.storage
        let group = DispatchGroup()
        
        var result: Result<URL, Swift.Error>!
        
        group.enter()
        storage.downloadURL { url, error in
            result = Result { try url ?? { throw error ?? UnexpectedValuesRepresentation() }() }
            group.leave()
        }
        group.wait()
        
        return try result.get()
    }
}
