//
//  ProfileViewController.swift
//  NawatechGallery
//
//  Created by Reynaldi on 20/08/23.
//

import UIKit
import Photos
import PhotosUI

public final class ProfileViewController: UIViewController, ResourceView, ResourceLoadingView, ResourceErrorView {
    
    @IBOutlet private(set) public var profileImageContainerView: UIView!
    @IBOutlet private(set) public var profileImageView: UIImageView!
    @IBOutlet private(set) public var editProfileImageButton: UIButton!
    @IBOutlet private(set) public var nameLabel: UILabel!
    @IBOutlet private(set) public var logoutButton: UIButton!
    
    private var selectedImagePicker: UIImage?
    
    public var retrieveProfile: (() -> Void)?
    public var logout: (() -> Void)?
    public var uploadImage: ((Data) -> Void)?
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
        
        if delegate == nil {
            profileImageView.isHidden = false
        } 
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
    
    @IBAction private func didTapEditProfileImage(_ sender: Any) {
        if #available(iOS 14.0, *) {
            openPHPicker()
        } else {
            openImagePicker()
        }
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        guard !isLoading else { return }
        logout?()
    }
}

//MARK: Upload Image UI State

extension ProfileViewController: UploadProfileImageSucceedView, UploadProfileImageLoadingView, UploadProfileImageErrorView {
    public func succeed() {
        guard let selectedImagePicker = selectedImagePicker else { return }
        profileImageView.image = selectedImagePicker
    }
    
    public func display(_ viewModel: SendResourceLoadingViewModel) {
        profileImageView.isHidden = viewModel.isLoading
        profileImageContainerView.isShimmering = viewModel.isLoading
    }
    
    public func display(_ viewModel: SendResourceErrorViewModel) {}
}

extension ProfileViewController: PHPickerViewControllerDelegate {
    private func openPHPicker() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let pickerController = PHPickerViewController(configuration: configuration)
        pickerController.delegate = self
        
        present(pickerController, animated: true)
    }
    
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            guard let image = object as? UIImage,
                  let data = image.pngData()
            else { return }
            
            DispatchQueue.main.async {
                self?.selectedImagePicker = image
                self?.uploadImage?(data)
            }
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func openImagePicker() {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .photoLibrary
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        present(pickerController, animated: true)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage,
              let data = image.pngData()
        else { return }
        
        selectedImagePicker = image
        uploadImage?(data)
    }
}
