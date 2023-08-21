//
//  CatalogueItemCell.swift
//  NawatechGallery
//
//  Created by Reynaldi on 21/08/23.
//

import UIKit

public final class CatalogueItemCell: UITableViewCell {
    @IBOutlet private(set) public var titleLabel: UILabel!
    @IBOutlet private(set) public var catalogueImageContainer: UIView!
    @IBOutlet private(set) public var catalogueImageView: UIImageView!
    
    var onReuse: (() -> Void)?
    
    public override func prepareForReuse() {
        onReuse?()
    }
}
