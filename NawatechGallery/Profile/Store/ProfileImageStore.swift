//
//  ProfileImageStore.swift
//  NawatechGallery
//
//  Created by Reynaldi on 22/08/23.
//

import Foundation

public protocol ProfileImageStore {
    func upload(_ data: Data, named name: String) throws -> URL
}
