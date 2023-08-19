//
//  LoginViewController.swift
//  NawatechGallery
//
//  Created by Reynaldi on 19/08/23.
//

import UIKit

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
}

extension LoginViewController: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        let (username, password) = extractLoginFieldsValue()
        updateLoginButtonUIState(isEnable: username?.isEmpty == false && password?.isEmpty == false)
    }
}
