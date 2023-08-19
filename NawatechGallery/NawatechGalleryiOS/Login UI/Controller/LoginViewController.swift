//
//  LoginViewController.swift
//  NawatechGallery
//
//  Created by Reynaldi on 19/08/23.
//

import UIKit

public typealias LoginAuthenticationAccount = (username: String, password: String)

public final class LoginViewController: UIViewController {
    
    @IBOutlet private(set) public var usernameField: UITextField!
    @IBOutlet private(set) public var passwordField: UITextField!
    @IBOutlet private(set) public var loginButton: UIButton!
    @IBOutlet private(set) public var signUpButton: UIButton!
    @IBOutlet private(set) public var skipLoginButton: UIButton!
    @IBOutlet private(set) public var loadingContainer: UIView!
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        loadingContainer.addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: loadingContainer.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: loadingContainer.centerYAnchor)
        ])
        
        return spinner
    }()
        
    public var isLoading: Bool {
        get { spinner.isAnimating }
        set {
            loginButton.titleLabel?.isHidden = newValue
            newValue ? spinner.startAnimating() : spinner.stopAnimating()
        }
    }
    
    public var errorMessage: String? = nil
        
    public var authenticate: ((LoginAuthenticationAccount) -> Void)?
    public var onSucceedAuthenticate: (() -> Void)?
    public var onRegister: (() -> Void)?
    public var onSkipLogin: (() -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInitialUI()
    }
    
    private func configureInitialUI() {
        updateLoginButtonUIState(isEnable: false)
        usernameField.delegate = self
        passwordField.delegate = self
    }
    
    private func updateLoginButtonUIState(isEnable: Bool) {
        loginButton.isEnabled = isEnable
        loginButton.layer.opacity = isEnable ? 1.0 : 0.5
    }
    
    private func extractLoginFieldsValue() -> (username: String?, password: String?) {
        return (usernameField.text, passwordField.text)
    }
    
    
    @IBAction func didTapLogin(_ sender: Any) {
        let value = extractLoginFieldsValue()
        guard let username = value.username, let password = value.password else { return }
        
        authenticate?(LoginAuthenticationAccount(username, password))
    }
    
    @IBAction func didTapSignUp(_ sender: Any) {
        onRegister?()
    }
    
    @IBAction func didTapSkipLogin(_ sender: Any) {
        onSkipLogin?()
    }
}

extension LoginViewController: AuthenticationSucceedView, AuthenticationLoadingView {
    public func succeed() {
        onSucceedAuthenticate?()
    }
    
    public func display(_ viewModel: AuthenticationLoadingViewModel) {
        isLoading = viewModel.isLoading
    }
}

extension LoginViewController: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        let (username, password) = extractLoginFieldsValue()
        updateLoginButtonUIState(isEnable: username?.isEmpty == false && password?.isEmpty == false)
    }
}
