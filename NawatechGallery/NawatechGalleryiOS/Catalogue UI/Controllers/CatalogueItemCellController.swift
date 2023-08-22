//
//  CatalogueItemCellController.swift
//  NawatechGallery
//
//  Created by Reynaldi on 21/08/23.
//

import UIKit

public protocol ListImageCellControllerDelegate {
    func didRequestImage()
    func didCancelRequestImage()
}

public final class CatalogueItemCellController: NSObject {
    private let viewModel: CatalogueItemViewModel
    private let delegate: ListImageCellControllerDelegate
    private let selection: () -> Void
    private var cell: CatalogueItemCell?
    
    public init(viewModel: CatalogueItemViewModel, delegate: ListImageCellControllerDelegate, selection: @escaping () -> Void) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.selection = selection
    }
}

extension CatalogueItemCellController: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        cell?.titleLabel.text = viewModel.title
        cell?.catalogueImageView.image = nil
        cell?.catalogueImageContainer.isShimmering = true
        
        cell?.onReuse = { [weak self] in
            self?.releaseCellForReuse()
        }
        delegate.didRequestImage()
        
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection()
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.cell = cell as? CatalogueItemCell
        delegate.didRequestImage()
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelLoad()
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        delegate.didRequestImage()
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        cancelLoad()
    }
    
    private func cancelLoad() {
        releaseCellForReuse()
        delegate.didCancelRequestImage()
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}

extension CatalogueItemCellController: ResourceView, ResourceLoadingView, ResourceErrorView {
    public typealias ResourceViewModel = UIImage
    
    public func display(_ viewModel: UIImage) {
        cell?.catalogueImageView.setImageAnimated(viewModel)
    }
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        cell?.catalogueImageContainer.isShimmering = viewModel.isLoading
    }
    
    public func display(_ viewModel: ResourceErrorViewModel) {
        cell?.catalogueImageView.image = UIImage()
    }
}
