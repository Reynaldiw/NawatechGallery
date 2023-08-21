//
//  AuthenticationFlow.swift
//  NawatechGallery
//
//  Created by Reynaldi on 20/08/23.
//

import Combine
import Foundation

final class AuthenticationFlow {
    
    private var loginController: LoginViewController?
    private var registrationController: RegistrationViewController?
    
    private lazy var scheduler: AnyDispatchQueueScheduler = DispatchQueue(
        label: "com.reynaldi.authentication.infra.queue",
        qos: .userInitiated,
        attributes: .concurrent
    ).eraseToAnyScheduler()
    
    private lazy var loginValidationService: AuthenticationValidationService = {
        AuthenticationValidationService(
            store: makeAuthenticationStore(queryFieldKey: "username"))
    }()
    
    private lazy var registrationService: RegistrationUserAccountService = {
        RegistrationUserAccountService(store: makeAuthenticationStore(queryFieldKey: "username"))
    }()
    
    private lazy var keychainAccountStore: AccountCacheStoreSaver = {
        return KeychainAccountCacheStore(storeKey: SharedKeys.accountKeychainKey)
    }()
    
    func start(
        onSucceedLogin: @escaping () -> Void
    ) -> LoginViewController {
        loginController = LoginUIComposer.loginComposedWith(
            loginAuthenticate: authenticateLogin(account:),
            onSucceedAuthenticate: onSucceedLogin,
            onRegister: routeToRegistrationPage
        )
        
        return loginController!
    }
    
    private func routeToRegistrationPage() {
        registrationController = RegistrationUIComposer.registerComposedWith(
            registerAuthenticate: authenticateRegistration(account:),
            onSucceedRegistration: handleSucceedRegistration
        )
        
        loginController?.show(registrationController!, sender: self)
    }
    
    private func handleSucceedRegistration() {
        registrationController?.navigationController?.popViewController(animated: true)
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
    
    private func authenticateRegistration(account: RegistrationAuthenticationAccount) -> AnyPublisher<Void, Error> {
        return registrationService
            .registerPublisher(
                RegistrationUserAccount(fullname: account.fullname, username: account.username, password: account.password))
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    private func makeAuthenticationStore(collectionPath: String = "users", queryFieldKey: String) -> FirestoreAuthenticationUserStore {
        FirestoreAuthenticationUserStore(queryFieldKey: queryFieldKey, collectionPath: collectionPath)
    }
}
