//
//  UploadImageProfileAdapter.swift
//  NawatechGallery
//
//  Created by Reynaldi on 22/08/23.
//

import Foundation
import Combine

typealias UploadProfileImageLoadingView = SendResourceLoadingView
typealias UploadProfileImageSucceedView = SendResourceSucceedView
typealias UploadProfileImageErrorView = SendResourceErrorView

final class UploadImageProfileAdapter {
    
    private typealias PresentationAdapter = SendResourcePresentationAdapter<Data>
    private typealias Presenter = SendResourcePresenter
    
    private weak var controller: ProfileViewController?
    private let imageUploader: (Data) -> AnyPublisher<Void, Error>
    
    init(controller: ProfileViewController, imageUploader: @escaping (Data) -> AnyPublisher<Void, Error>) {
        self.controller = controller
        self.imageUploader = imageUploader
    }
    
    private lazy var adapter: PresentationAdapter = {
        PresentationAdapter(sender: imageUploader)
    }()

    func upload(_ data: Data) {
        guard let controller = controller else { return }
        
        adapter.presenter = Presenter(
            succeedView: controller,
            loadingView: controller,
            errorView: controller)
        
        adapter.send(data)
    }
}
