//
//  LoginErrorViewAdapter.swift
//  NawatechGallery
//
//  Created by Reynaldi on 20/08/23.
//

import Foundation

final class LoginErrorViewAdapter: SendResourceErrorView {
    
    public weak var controller: LoginViewController?
    
    init(controller: LoginViewController?) {
        self.controller = controller
    }
    
    private static var errorMessageUsernameNotMatch: String {
        "Incorrect username"
    }
    
    private static var errorMessagePasswordNotMatch: String {
        "Incorrect username"
    }
    
    func display(_ viewModel: SendResourceErrorViewModel) {
        guard let error = viewModel.error else { return }
        guard let validationError = error as? AuthenticationValidationService.Error else {
            return displayDefaultErrorMessage(viewModel)
        }
        
        if validationError == .notFound {
            controller?.errorMessage = Self.errorMessageUsernameNotMatch
        } else if validationError == .passwordNotMatched {
            controller?.errorMessage = Self.errorMessagePasswordNotMatch
        } else {
            displayDefaultErrorMessage(viewModel)
        }
    }
    
    private func displayDefaultErrorMessage(_ viewModel: SendResourceErrorViewModel) {
        controller?.errorMessage = viewModel.message ?? SendResourcePresenter.sendResourceError
    }
}
