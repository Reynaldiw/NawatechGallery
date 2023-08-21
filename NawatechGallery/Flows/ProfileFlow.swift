//
//  ProfileFlow.swift
//  NawatechGallery
//
//  Created by Reynaldi on 21/08/23.
//

import Combine
import Foundation

final class ProfileFlow {
    
    private lazy var scheduler: AnyDispatchQueueScheduler = DispatchQueue(
        label: "com.reynaldi.profile.infra.queue",
        qos: .userInitiated,
        attributes: .concurrent
    ).eraseToAnyScheduler()
    
    private lazy var accountCacheService: AccountCacheStoreRetriever & AccountCacheStoreRemover = {
        KeychainAccountCacheStore(storeKey: SharedKeys.accountKeychainKey)
    }()
    
    private lazy var accountStoreRetriever: UserAccountStoreRetriever = {
        FirestoreUserAccountClient()
    }()
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    func start(
        onLogout: @escaping () -> Void
    ) -> ProfileViewController {
        let profileController = ProfileUIComposer.profileComposedWith(
            loadProfile: loadProfile,
            imageLoader: loadImage(from:),
            logout: { [weak self] in
                self?.logout()
                onLogout()
            })
        
        return profileController
    }
    
    private func loadProfile() -> AnyPublisher<ProfileUserAccount, Error> {
        return accountCacheService.retrievePublisher()
            .flatMap { [accountStoreRetriever] value in
                accountStoreRetriever.retrievePublisher(.matched((value!, "id")))
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
    
    private func logout() {
        try? accountCacheService.delete()
    }
}
