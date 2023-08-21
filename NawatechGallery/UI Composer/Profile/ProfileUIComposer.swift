//
//  ProfileUIComposer.swift
//  NawatechGallery
//
//  Created by Reynaldi on 21/08/23.
//

import Combine
import UIKit

final class ProfileUIComposer {
    private init() {}
    
    private typealias ProfilePresentationAdapter = LoadResourcePresentationAdapter<ProfileUserAccount, ProfileViewAdapter>
    
    func profileComposedWith(
        loadProfile: @escaping () -> AnyPublisher<ProfileUserAccount, Error>,
        logout: @escaping () -> Void
    ) -> ProfileViewController {
        let adapter = ProfilePresentationAdapter(loader: loadProfile)
        
        let profileController = makeProfileController(title: "My Profile")
        profileController.retrieveProfile = adapter.loadResource
        profileController.logout = logout
        
        adapter.presenter = LoadResourcePresenter(
            resourceView: ProfileViewAdapter(controller: profileController),
            loadingView: WeakRefVirtualProxy(object: profileController),
            errorView: WeakRefVirtualProxy(object: profileController))
        
        return profileController
    }
    
    private func makeProfileController(title: String) -> ProfileViewController {
        let bundle = Bundle(for: ProfileViewController.self)
        let storyboard = UIStoryboard(name: "Profile", bundle: bundle)
        let profileController = storyboard.instantiateInitialViewController() as! ProfileViewController
        profileController.title = title
        
        return profileController
    }
}
