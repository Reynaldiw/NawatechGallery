//
//  AuthenticateAccountPresenter.swift
//  NawatechGallery
//
//  Created by Reynaldi on 19/08/23.
//

import Foundation

public final class AuthenticateAccountPresenter {
    
    private let succeedView: AuthenticationSucceedView
    private let loadingView: AuthenticationLoadingView
    private let errorView: AuthenticationErrorView
    
    public init(succeedView: AuthenticationSucceedView, loadingView: AuthenticationLoadingView, errorView: AuthenticationErrorView) {
        self.succeedView = succeedView
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    public static var authenticateError: String {
        "Something went wrong"
    }
    
    public func didStartLoading() {
        errorView.display(.noError)
        loadingView.display(AuthenticationLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoading(with error: Error?) {
        if let error = error {
            errorView.display(.error(error, message: Self.authenticateError))
        } else {
            succeedView.succeed()
        }
        loadingView.display(AuthenticationLoadingViewModel(isLoading: false))
    }
}
