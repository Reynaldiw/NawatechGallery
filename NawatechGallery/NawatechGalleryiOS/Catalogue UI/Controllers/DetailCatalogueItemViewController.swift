//
//  DetailCatalogueItemViewController.swift
//  NawatechGallery
//
//  Created by Reynaldi on 22/08/23.
//

import UIKit

public final class DetailCatalogueItemViewController: UIViewController {
    
    @IBOutlet private(set) public var itemImageContainerView: UIView!
    @IBOutlet private(set) public var itemImageView: UIImageView!
    @IBOutlet private(set) public var priceLabel: UILabel!
    @IBOutlet private(set) public var titleLabel: UILabel!
    @IBOutlet private(set) public var detailLabel: UILabel!
    @IBOutlet private(set) public var addToCartButton: UIButton!
    
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
        
    public var isLoading: Bool {
        get { spinner.isAnimating }
        set {
            newValue ? spinner.startAnimating() : spinner.stopAnimating()
        }
    }
    
    public var loadDetail: (() -> Void)?
    public var addToCart: (() -> Void)?
    public var delegate: ListImageCellControllerDelegate?

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInitialUI()
        loadDetail?()
    }
    
    private func configureInitialUI() {
        itemImageContainerView.isHidden = true
        itemImageView.isHidden = true
        priceLabel.text = ""
        titleLabel.text = ""
        detailLabel.text = ""
        addToCartButton.isHidden = true
    }
    
    private func updateCartButtonUIState(isEnable: Bool) {
        addToCartButton.isEnabled = isEnable
        addToCartButton.layer.opacity = isEnable ? 1.0 : 0.5
    }
    
    @IBAction private func didTapAddToCart(_ sender: Any) {
        addToCart?()
    }
    
    deinit {
        delegate?.didCancelRequestImage()
    }
}

extension DetailCatalogueItemViewController: ResourceView {
    public typealias ResourceViewModel = UIImage
    
    public func display(_ viewModel: UIImage) {
        itemImageView.isHidden = false
        itemImageView.setImageAnimated(viewModel)
    }
    
    public func displayImageView(_ isLoading: Bool) {
        itemImageContainerView.isShimmering = isLoading
    }
}

extension DetailCatalogueItemViewController: ResourceLoadingView, ResourceErrorView {
    public func display(_ viewModel: DetailCatalogueItemViewModel) {
        priceLabel.text = viewModel.price
        titleLabel.text = viewModel.title
        detailLabel.text = viewModel.detail
        addToCartButton.setTitle(viewModel.cartButtonText, for: .normal)
        updateCartButtonUIState(isEnable: viewModel.cartButtonEnable)
        
        delegate?.didRequestImage()
        
        itemImageContainerView.isHidden = false
        addToCartButton.isHidden = false
    }
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        isLoading = viewModel.isLoading
    }
    
    public func display(_ viewModel: ResourceErrorViewModel) {}
}

extension DetailCatalogueItemViewController: SendResourceSucceedView, SendResourceLoadingView, SendResourceErrorView {
    public func succeed() {
        showMessage(title: "Succeed", message: "Succeed add to cart!") { [loadDetail] _ in
            loadDetail?()
        }
    }
    
    public func display(_ viewModel: SendResourceLoadingViewModel) {
        isLoading = viewModel.isLoading
    }
    
    public func display(_ viewModel: SendResourceErrorViewModel) {
        guard let errorMessage = viewModel.message else { return }
        showMessage(title: "Error", message: errorMessage, actionTitle: "Try again!") { [addToCart] _ in
            addToCart?()
        }
    }
    
    private func showMessage(
        title: String,
        message: String,
        actionTitle: String = "Ok",
        actionHandler: ((UIAlertAction) -> Void)? = nil
    ) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .cancel, handler: actionHandler)
        controller.addAction(action)
        
        present(controller, animated: true)
    }
}
