//
//  LoginSnapshotTest.swift
//  NawatechGalleryTests
//
//  Created by Reynaldi on 19/08/23.
//

import XCTest
import NawatechGallery

final class LoginSnapshotTest: XCTestCase {
    
    func test_loginInitialSetup() {
        let bundle = Bundle(for: LoginViewController.self)
        let storyboard = UIStoryboard(name: "Login", bundle: bundle)
        let sut = storyboard.instantiateInitialViewController() as! LoginViewController
        sut.loadViewIfNeeded()
        
        assert(snapshot: sut.snapshot(configuration: .iPhone13(style: .light)), named: "LOGIN_INITIAL_SETUP_light")
    }
    
    func test_loginFieldsFilled() {
        let bundle = Bundle(for: LoginViewController.self)
        let storyboard = UIStoryboard(name: "Login", bundle: bundle)
        let sut = storyboard.instantiateInitialViewController() as! LoginViewController
        sut.loadViewIfNeeded()
        sut.fillFields(withUsername: "Test username", andPassword: "test password")
        
        assert(snapshot: sut.snapshot(configuration: .iPhone13(style: .light)), named: "LOGIN_FIELDS_FILLED_light")
    }
}

private extension LoginViewController {
    func fillFields(withUsername username: String, andPassword password: String) {
        usernameField.text = username
        passwordField.text = password
        textFieldDidEndEditing(usernameField)
        textFieldDidEndEditing(passwordField)
    }
}
