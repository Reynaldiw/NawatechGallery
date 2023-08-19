//
//  WeakRefVirtualProxy.swift
//  NawatechGallery
//
//  Created by Reynaldi on 20/08/23.
//

import Foundation

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: AuthenticationLoadingView where T: AuthenticationLoadingView {
    func display(_ viewModel: AuthenticationLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: AuthenticationSucceedView where T: AuthenticationSucceedView {
    func succeed() {
        object?.succeed()
    }
}
