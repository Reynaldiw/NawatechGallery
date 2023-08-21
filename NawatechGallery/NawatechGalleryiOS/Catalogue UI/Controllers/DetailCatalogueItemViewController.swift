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

    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func didTapAddToCart(_ sender: Any) {
        
    }
}
