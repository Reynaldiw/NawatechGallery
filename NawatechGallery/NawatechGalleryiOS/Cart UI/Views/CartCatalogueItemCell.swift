//
//  CartCatalogueItemCell.swift
//  NawatechGallery
//
//  Created by Reynaldi on 22/08/23.
//

import UIKit

public final class CartCatalogueItemCell: UITableViewCell {

    @IBOutlet private(set) public var itemImageContainerView: UIView!
    @IBOutlet private(set) public var itemImageView: UIImageView!
    @IBOutlet private(set) public var titleLabel: UILabel!
    @IBOutlet private(set) public var itemPriceLabel: UILabel!
    @IBOutlet private(set) public var quantityLabel: UILabel!
    @IBOutlet private(set) public var totalItemPrice: UILabel!
    
    var onReuse: (() -> Void)?
    
    public override func prepareForReuse() {
        onReuse?()
    }
}
