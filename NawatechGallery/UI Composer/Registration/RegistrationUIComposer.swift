//
//  RegistrationUIComposer.swift
//  NawatechGallery
//
//  Created by Reynaldi on 20/08/23.
//

import UIKit
import Combine
import Foundation

public final class RegistrationUIComposer {
    private init() {}
    
    private typealias RegistrationPresentationAdapter = SendResourcePresentationAdapter<RegistrationAuthenticationAccount>
    
    public static func registerComposedWith(
        registerAuthenticate: @escaping (RegistrationAuthenticationAccount) -> AnyPublisher<Void, Error>,
        onSucceedRegistration: @escaping () -> Void = { }
    ) -> RegistrationViewController {
        let presentationAdapter = RegistrationPresentationAdapter(sender: registerAuthenticate)
        
        let registrationController = makeRegistrationViewController()
        registrationController.register = presentationAdapter.send
        registrationController.onSucceedRegistration = onSucceedRegistration
        
        presentationAdapter.presenter = SendResourcePresenter(
            succeedView: WeakRefVirtualProxy(object: registrationController),
            loadingView: WeakRefVirtualProxy(object: registrationController),
            errorView: RegistrationErrorViewAdapter(controller: registrationController))
        
        return registrationController
    }
    
    private static func makeRegistrationViewController() -> RegistrationViewController {
        let bundle = Bundle(for: RegistrationViewController.self)
        let storyboard = UIStoryboard(name: "Registration", bundle: bundle)
        let registrationViewController = storyboard.instantiateInitialViewController() as! RegistrationViewController
        registrationViewController.title = ""
        
        return registrationViewController
    }
}
