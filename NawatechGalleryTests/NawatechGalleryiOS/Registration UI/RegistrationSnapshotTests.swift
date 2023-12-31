//
//  RegistrationSnapshotTests.swift
//  NawatechGalleryTests
//
//  Created by Reynaldi on 19/08/23.
//

import XCTest
import NawatechGallery

final class RegistrationSnapshotTests: XCTestCase {

    func test_registrationInitialSetup() {
        let sut = makeSUT()
        
        assert(snapshot: sut.snapshot(configuration: .iPhone13(style: .light)), named: "REGISTRATION_INITIAL_SETUP_light")
    }
    
    func test_registrationWithNotAllOfFieldsIsFilled() {
        let sut = makeSUT()
        sut.fillFields(fullname: "Test fullname", username: "Test username", password: nil)
        
        assert(snapshot: sut.snapshot(configuration: .iPhone13(style: .light)), named: "REGISTRATION_NOT_ALL_FIELDS_FILLED_light")
    }
    
    func test_registrationFieldsFilled() {
        let sut = makeSUT()
        sut.fillFields(fullname: "Test fullname", username: "Test username", password: "test password")
        
        assert(snapshot: sut.snapshot(configuration: .iPhone13(style: .light)), named: "REGISTRATION_FIELDS_FILLED_light")
    }
    
    func test_registrationWithLoading() {
        let sut = makeSUT()
        sut.fillFields(fullname: "Test fullname", username: "Test username", password: "test password")
        sut.isLoading = true
        
        assert(snapshot: sut.snapshot(configuration: .iPhone13(style: .light)), named: "REGISTRATION_LOADING_light")
    }
    
    //MARK: - Helpers
    
    private func makeSUT() -> RegistrationViewController {
        let bundle = Bundle(for: RegistrationViewController.self)
        let storyboard = UIStoryboard(name: "Registration", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! RegistrationViewController
        controller.loadViewIfNeeded()
        
        return controller
    }
}

private extension RegistrationViewController {
    func fillFields(fullname: String?, username: String?, password: String?) {
        fullnameField.text = fullname
        usernameField.text = username
        passwordField.text = password
        textFieldDidChangeSelection(fullnameField)
        textFieldDidChangeSelection(usernameField)
        textFieldDidChangeSelection(passwordField)
    }
}

