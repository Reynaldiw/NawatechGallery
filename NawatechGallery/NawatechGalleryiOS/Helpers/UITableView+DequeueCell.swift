//
//  UITableView+DequeueCell.swift
//  NawatechGallery
//
//  Created by Reynaldi on 22/08/23.
//

import UIKit

public extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
