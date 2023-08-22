//
//  WeakRefVirtualProxy.swift
//  NawatechGallery
//
//  Created by Reynaldi on 20/08/23.
//

import UIKit

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: SendResourceErrorView where T: SendResourceErrorView {
    func display(_ viewModel: SendResourceErrorViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: SendResourceLoadingView where T: SendResourceLoadingView {
    func display(_ viewModel: SendResourceLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: SendResourceSucceedView where T: SendResourceSucceedView {
    func succeed() {
        object?.succeed()
    }
}

extension WeakRefVirtualProxy: ResourceView where T: ResourceView, T.ResourceViewModel == UIImage {
    func display(_ viewModel: UIImage) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: ResourceLoadingView where T: ResourceLoadingView {
    func display(_ viewModel: ResourceLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: ResourceErrorView where T: ResourceErrorView {
    func display(_ viewModel: ResourceErrorViewModel) {
        object?.display(viewModel)
    }
}

