//
//  UploadImageProfileAdapter.swift
//  NawatechGallery
//
//  Created by Reynaldi on 22/08/23.
//

import Foundation
import Combine

typealias UploadProfileImageLoadingView = AuthenticationLoadingView
typealias UploadProfileImageSucceedView = AuthenticationSucceedView
typealias UploadProfileImageErrorView = AuthenticationErrorView

final class UploadImageProfileAdapter {
    
    private typealias PresentationAdapter = AuthenticateAccountPresentationAdapter<Data>
    private typealias Presenter = AuthenticateAccountPresenter
    
    private weak var controller: ProfileViewController?
    private let imageUploader: (Data) -> AnyPublisher<Void, Error>
    
    init(controller: ProfileViewController, imageUploader: @escaping (Data) -> AnyPublisher<Void, Error>) {
        self.controller = controller
        self.imageUploader = imageUploader
    }
    
    private lazy var adapter: PresentationAdapter = {
        PresentationAdapter(authenticate: imageUploader)
    }()

    func upload(_ data: Data) {
        guard let controller = controller else { return }
        
        adapter.presenter = Presenter(
            succeedView: controller,
            loadingView: controller,
            errorView: controller)
        
        adapter.upload(data)
    }
}

extension AuthenticateAccountPresentationAdapter where Account == Data {
    func upload(_ data: Data) {
        self.authenticate(data)
    }
}
