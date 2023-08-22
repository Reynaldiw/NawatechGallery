//
//  SendResourcePresenter.swift
//  NawatechGallery
//
//  Created by Reynaldi on 19/08/23.
//

import Foundation

public final class SendResourcePresenter {
    
    private let succeedView: SendResourceSucceedView
    private let loadingView: SendResourceLoadingView
    private let errorView: SendResourceErrorView
    
    public init(succeedView: SendResourceSucceedView, loadingView: SendResourceLoadingView, errorView: SendResourceErrorView) {
        self.succeedView = succeedView
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    public static var sendResourceError: String {
        "Something went wrong"
    }
    
    public func didStartLoading() {
        errorView.display(.noError)
        loadingView.display(SendResourceLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoading(with error: Error?) {
        if let error = error {
            errorView.display(.error(error, message: Self.sendResourceError))
        } else {
            succeedView.succeed()
        }
        loadingView.display(SendResourceLoadingViewModel(isLoading: false))
    }
}
