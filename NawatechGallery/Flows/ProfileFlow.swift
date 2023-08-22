//
//  ProfileFlow.swift
//  NawatechGallery
//
//  Created by Reynaldi on 21/08/23.
//

import Combine
import Foundation
import FirebaseFirestore

final class ProfileFlow {
    
    private lazy var scheduler: AnyDispatchQueueScheduler = DispatchQueue(
        label: "com.reynaldi.profile.infra.queue",
        qos: .userInitiated,
        attributes: .concurrent
    ).eraseToAnyScheduler()
    
    private lazy var accountCacheService: AccountCacheStoreRetriever & AccountCacheStoreRemover = {
        KeychainAccountCacheStore(storeKey: SharedKeys.accountKeychainKey)
    }()
    
    private lazy var accountStore: StoreRetriever & StoreModifier = {
        SharedFirestoreClient(collectionReference: Firestore.firestore().collection("users"))
    }()
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var profileImageStore: ProfileImageStore = {
       FirebaseStorageProfileImageStore()
    }()
    
    func start(
        onLogout: @escaping () -> Void
    ) -> ProfileViewController {
        let profileController = ProfileUIComposer.profileComposedWith(
            loadProfile: loadProfile,
            imageLoader: loadImage(from:),
            imageUploader: upload(_:),
            logout: { [weak self] in
                self?.logout()
                onLogout()
            })
        
        return profileController
    }
    
    private func loadProfile() -> AnyPublisher<ProfileUserAccount, Error> {
        return accountCacheService.retrievePublisher()
            .tryCompactMap { $0 }
            .flatMap { [accountStore] value in
                accountStore.retrievePublisher(.matched((value, "id")))
            }
            .tryMap(ProfileUserAccountMapper.map(_:))
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    private func loadImage(from url: URL) -> AnyPublisher<Data, Error> {
        return httpClient
            .getPublisher(from: url)
            .tryMap(GalleryImageDataMapper.map)
            .receive(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    private func upload(_ data: Data) -> AnyPublisher<Void, Error> {
        return accountCacheService
            .retrievePublisher()
            .tryCompactMap { $0 }
            .flatMap { [profileImageStore, accountStore] accountID in
                profileImageStore.uploadPublisher(data, named: accountID)
                    .flatMap { [accountStore] url in
                        accountStore.updatePublisher("profile_image_url", with: url.absoluteString, in: accountID)
                    }
            }
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    private func logout() {
        try? accountCacheService.delete()
    }
}
