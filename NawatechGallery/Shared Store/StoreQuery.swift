//
//  StoreQuery.swift
//  NawatechGallery
//
//  Created by Reynaldi on 21/08/23.
//

import Foundation

public enum StoreQuery {
    case all
    case matched((value: Any, key: String))
}
