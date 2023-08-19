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
