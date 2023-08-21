//
//  ProfileViewController.swift
//  NawatechGallery
//
//  Created by Reynaldi on 20/08/23.
//

import UIKit

public final class ProfileViewController: UIViewController, ResourceView, ResourceLoadingView, ResourceErrorView {
    
    @IBOutlet private(set) public var profileImageContainerView: UIView!
    @IBOutlet private(set) public var profileImageView: UIImageView!
    @IBOutlet private(set) public var editProfileImageButton: UIButton!
    @IBOutlet private(set) public var nameLabel: UILabel!
    @IBOutlet private(set) public var logoutButton: UIButton!
    
    public var retrieveProfile: (() -> Void)?
    public var logout: (() -> Void)?
    public var delegate: ListImageCellControllerDelegate?
    
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
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.didCancelRequestImage()
    }
    
    private func configureInitialUI() {
        editProfileImageButton.isHidden = true
        nameLabel.isHidden = true
        logoutButton.isHidden = true
        profileImageView.isHidden = true
        profileImageContainerView.isShimmering = isLoading
    }
    
    //MARK: Profile UI State
    
    public func display(_ account: ProfileUserAccount) {
        nameLabel.text = account.fullname
        delegate?.didRequestImage()
        
        nameLabel.isHidden = false
        editProfileImageButton.isHidden = false
        logoutButton.isHidden = false
    }
        
    public func display(_ viewModel: ResourceLoadingViewModel) {
        isLoading = viewModel.isLoading
    }
    
    public func display(_ viewModel: ResourceErrorViewModel) {
        nameLabel.isHidden = viewModel.message == nil
        nameLabel.text = viewModel.message
    }
    
    //MARK: Profile Image UI State
    
    public typealias ResourceViewModel = UIImage
    
    public func display(_ viewModel: ResourceViewModel) {
        profileImageView.isHidden = false
        profileImageView.setImageAnimated(viewModel)
    }
    
    public func displayLoadingImage(_ isLoading: Bool) {
        profileImageContainerView.isShimmering = isLoading
    }
    
    public func displayErrorImageProfile() {
        profileImageView.isHidden = false
    }
    
    @IBAction private func didTapEditProfileImage(_ sender: Any) {}
    
    @IBAction func didTapLogout(_ sender: Any) {
        guard !isLoading else { return }
        logout?()
    }
}
