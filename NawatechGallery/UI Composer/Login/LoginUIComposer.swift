//
//  LoginUIComposer.swift
//  NawatechGallery
//
//  Created by Reynaldi on 20/08/23.
//

import UIKit
import Combine
import Foundation

public final class LoginUIComposer {
    private init() {}
    
    private typealias LoginPresentationAdapter = AuthenticateAccountPresentationAdapter<LoginAuthenticationAccount>
    
    public static func loginComposedWith(
        loginAuthenticate: @escaping (LoginAuthenticationAccount) -> AnyPublisher<Void, Error>,
        onSucceedAuthenticate: @escaping () -> Void = { },
        onRegister: @escaping () -> Void = { },
        onSkipLogin: @escaping () -> Void = { }
    ) {
        let presentationAdapter = LoginPresentationAdapter(authenticate: loginAuthenticate)
        
        let loginController = makeLoginViewController()
        loginController.authenticate = presentationAdapter.authenticate
        loginController.onSucceedAuthenticate = onSucceedAuthenticate
        loginController.onSkipLogin = onSkipLogin
        loginController.onRegister = onRegister
        
        presentationAdapter.presenter = AuthenticateAccountPresenter(
            succeedView: WeakRefVirtualProxy(object: loginController),
            loadingView: WeakRefVirtualProxy(object: loginController),
            errorView: LoginErrorViewAdapter(controller: loginController))
    }
    
    private static func makeLoginViewController() -> LoginViewController {
        let bundle = Bundle(for: LoginViewController.self)
        let storyboard = UIStoryboard(name: "Login", bundle: bundle)
        let loginViewController = storyboard.instantiateInitialViewController() as! LoginViewController
        loginViewController.title = ""
        
        return loginViewController
    }
}
