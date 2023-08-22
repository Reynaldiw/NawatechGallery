//
//  StoreSaver.swift
//  NawatechGallery
//
//  Created by Reynaldi on 22/08/23.
//

import Foundation

public protocol StoreSaver {
    func save(_ value: [String : Any], namedWith name: String) throws
}
