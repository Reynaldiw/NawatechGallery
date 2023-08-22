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
    private let cartFlow = CartCatalogueFlow()

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
            window?.rootViewController = makeMainTabBarController(onLogout: makeInitialRootViewController)
        } else {
            window?.rootViewController = UINavigationController(
                rootViewController: authenticationFlow.start(onSucceedLogin: makeInitialRootViewController))
        }
    }
    
    private func makeMainTabBarController(onLogout: @escaping () -> Void) -> MainTabBarViewController {
        let catalogueViewModel = MainTabBarViewModel(
            controller: UINavigationController(rootViewController: catalogueFlow.start()),
            imageSelected: UIImage(named: "tabbar_home_selected")!,
            imageNotSelected: UIImage(named: "tabbar_home_notselected")!)
        
        let cartViewModel = MainTabBarViewModel(
            controller: UINavigationController(rootViewController: cartFlow.start()),
            imageSelected: UIImage(named: "tabbar_cart_selected")!,
            imageNotSelected: UIImage(named: "tabbar_cart_notselected")!)
        
        let profileViewModel = MainTabBarViewModel(
            controller: profileFlow.start(onLogout: onLogout),
            imageSelected: UIImage(named: "tabbar_profile_selected")!,
            imageNotSelected: UIImage(named: "tabbar_profile_notselected")!)
        
        return MainTabBarViewController(
            viewModels: [catalogueViewModel, cartViewModel, profileViewModel],
            nibName: nil,
            bundle: Bundle(for: MainTabBarViewController.self))
    }
}

