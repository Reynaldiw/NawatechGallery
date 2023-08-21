//
//  ProfileViewController.swift
//  NawatechGallery
//
//  Created by Reynaldi on 20/08/23.
//

import UIKit

public final class ProfileViewController: UIViewController, ResourceLoadingView, ResourceErrorView {
    
    @IBOutlet private(set) public var profileImageView: UIImageView!
    @IBOutlet private(set) public var editProfileImageButton: UIButton!
    @IBOutlet private(set) public var nameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    public var retrieveProfile: (() -> Void)?
    public var logout: (() -> Void)?
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        view.addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return spinner
    }()
    
    private var isLoading: Bool {
        get { spinner.isAnimating }
        set { newValue ? spinner.startAnimating() : spinner.stopAnimating() }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        configureInitialUI()
        retrieveProfile?()
    }
    
    private func configureInitialUI() {
        profileImageView.isHidden = true
        editProfileImageButton.isHidden = true
        nameLabel.isHidden = true
        logoutButton.isHidden = true
    }
    
    public func display(_ account: ProfileUserAccount) {
        nameLabel.text = account.fullname
        
        nameLabel.isHidden = false
        editProfileImageButton.isHidden = false
        logoutButton.isHidden = false
    }
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        isLoading = viewModel.isLoading
    }
    
    public func display(_ viewModel: ResourceErrorViewModel) {}
    
    @IBAction private func didTapEditProfileImage(_ sender: Any) {}
    
    @IBAction func didTapLogout(_ sender: Any) {
        guard !isLoading else { return }
        logout?()
    }
}
