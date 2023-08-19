//
//  RegistrationViewController.swift
//  NawatechGallery
//
//  Created by Reynaldi on 19/08/23.
//

import UIKit

public typealias RegistrationAuthenticationAccount = (fullname: String, username: String, password: String)

public final class RegistrationViewController: UIViewController {
    
    @IBOutlet private(set) public var fullnameField: UITextField!
    @IBOutlet private(set) public var usernameField: UITextField!
    @IBOutlet private(set) public var passwordField: UITextField!
    @IBOutlet private(set) public var registerButton: UIButton!
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
            loadingContainer.isHidden = !newValue
            registerButton.titleLabel?.isHidden = newValue
            newValue ? spinner.startAnimating() : spinner.stopAnimating()
        }
    }
    
    public var errorMessage: String? = nil
    
    public var register: ((RegistrationAuthenticationAccount) -> Void)?
    public var onSucceedRegistration: (() -> Void)?

    public override func viewDidLoad() {
        super.viewDidLoad()

        configureInitialUI()
    }
    
    private func configureInitialUI() {
        loadingContainer.isHidden = true
        updateLoginButtonUIState(isEnable: false)
        fullnameField.delegate = self
        usernameField.delegate = self
        passwordField.delegate = self
    }
    
    private func updateLoginButtonUIState(isEnable: Bool) {
        registerButton.isEnabled = isEnable
        registerButton.layer.opacity = isEnable ? 1.0 : 0.5
    }
    
    private func extractRegistrationFieldsValue() -> (fullname: String?, username: String?, password: String?) {
        return (fullnameField.text, usernameField.text, passwordField.text)
    }
    
    
    @IBAction private func didTapRegister(_ sender: Any) {
        let value = extractRegistrationFieldsValue()
        guard let fullname = value.fullname, let username = value.username, let password = value.password else { return }
        
        register?(RegistrationAuthenticationAccount(fullname, username, password))
    }
}

extension RegistrationViewController: AuthenticationSucceedView, AuthenticationLoadingView {
    public func succeed() {
        onSucceedRegistration?()
    }
    
    public func display(_ viewModel: AuthenticationLoadingViewModel) {
        isLoading = viewModel.isLoading
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        let (fullname, username, password) = extractRegistrationFieldsValue()
        updateLoginButtonUIState(isEnable: fullname?.isEmpty == false && username?.isEmpty == false && password?.isEmpty == false)
    }
}
