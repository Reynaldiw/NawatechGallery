//
//  AuthenticationFlow.swift
//  NawatechGallery
//
//  Created by Reynaldi on 20/08/23.
//

import Combine
import Foundation

final class AuthenticationFlow {
    
    private lazy var scheduler: AnyDispatchQueueScheduler = DispatchQueue(
        label: "com.reynaldi.authentication.infra.queue",
        qos: .userInitiated,
        attributes: .concurrent
    ).eraseToAnyScheduler()
    
    private var accountKeychainKey: String {
        "account-keychain-key"
    }
    
    private lazy var loginValidationService: AuthenticationValidationService = {
        AuthenticationValidationService(
            store: makeAuthenticationUserStore(queryFieldKey: "username"))
    }()
    
    private lazy var keychainAccountStore: AccountCacheStoreSaver = {
        return KeychainAccountCacheStore(storeKey: accountKeychainKey)
    }()
    
    func start() -> LoginViewController {
        let controller = LoginUIComposer.loginComposedWith(
            loginAuthenticate: authenticateLogin(account:))
        return controller
    }
    
    private func authenticateLogin(account: LoginAuthenticationAccount) -> AnyPublisher<Void, Error> {
        return loginValidationService
            .validatePublisher(
                AuthenticationUserBody(username: account.username, password: account.password))
            .caching(to: keychainAccountStore)
            .map { _ in Void() }
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    private func makeAuthenticationUserStore(collectionPath: String = "users", queryFieldKey: String) -> AuthenticationUserStore {
        return FirestoreAuthenticationUserStore(queryFieldKey: queryFieldKey, collectionPath: collectionPath)
    }
}
