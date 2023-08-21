//
//  SceneDelegate.swift
//  NawatechGallery
//
//  Created by Reynaldi on 16/08/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private let authenticationFlow = AuthenticationFlow()
    private let catalogue = MotorcycleCatalogueFlow()
    
    private lazy var loginNavigationController: UINavigationController = {
        UINavigationController(rootViewController: catalogue.start())
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
                
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        window?.rootViewController = loginNavigationController
        window?.makeKeyAndVisible()
    }
}

