//
//  SceneDelegate.swift
//  NawatechGallery
//
//  Created by Reynaldi on 16/08/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private lazy var accountCacheRetriever: AccountCacheStoreRetriever = {
        KeychainAccountCacheStore(storeKey: SharedKeys.accountKeychainKey)
    }()
    
    private let authenticationFlow = AuthenticationFlow()
    private let catalogueFlow = MotorcycleCatalogueFlow()
    private let profileFlow = ProfileFlow()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
                
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        makeInitialRootViewController()
        window?.makeKeyAndVisible()
    }
    
    private func makeInitialRootViewController() {
        let cacheAccountID = try? accountCacheRetriever.retrieve()
        
        if cacheAccountID != nil {
            window?.rootViewController = UINavigationController(rootViewController: profileFlow.start(onLogout: makeInitialRootViewController))
        } else {
            window?.rootViewController = UINavigationController(rootViewController: authenticationFlow.start(onSucceedLogin: makeInitialRootViewController))
        }
    }
}

