//
//  ProfileViewAdapter.swift
//  NawatechGallery
//
//  Created by Reynaldi on 21/08/23.
//

import Combine
import UIKit

final class ProfileImageViewAdapter: ResourceLoadingView, ResourceErrorView {
    private weak var controller: ProfileViewController?

    init(controller: ProfileViewController) {
        self.controller = controller
    }
    
    func display(_ viewModel: ResourceLoadingViewModel) {
        controller?.displayLoadingImage(viewModel.isLoading)
    }
    
    func display(_ viewModel: ResourceErrorViewModel) {
        guard viewModel.error != nil else { return }
        controller?.displayErrorImageProfile()
    }
}

final class ProfileViewAdapter: ResourceView {
    
    private weak var controller: ProfileViewController?
    private let imageLoader: (URL) -> AnyPublisher<Data, Error>
    
    private typealias ImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, WeakRefVirtualProxy<ProfileViewController>>
    
    init(controller: ProfileViewController, imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: ProfileUserAccount) {
        if let profileImageURL = viewModel.profileImageURL, let controller = controller {
            let adapter = ImageDataPresentationAdapter(loader: { [imageLoader] in
                imageLoader(profileImageURL)
            })
            controller.delegate = adapter
            
            let view = ProfileImageViewAdapter(controller: controller)
            
            adapter.presenter = LoadResourcePresenter(
                resourceView: WeakRefVirtualProxy(object: controller),
                loadingView: view,
                errorView: view,
                mapper: UIImage.tryMake)
        }
        
        controller?.display(viewModel)
    }
}
