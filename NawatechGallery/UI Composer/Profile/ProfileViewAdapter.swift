//
//  ProfileViewAdapter.swift
//  NawatechGallery
//
//  Created by Reynaldi on 21/08/23.
//

import Foundation

final class ProfileViewAdapter: ResourceView {
    
    private weak var controller: ProfileViewController?
    
    init(controller: ProfileViewController) {
        self.controller = controller
    }
    
    func display(_ viewModel: ProfileUserAccount) {
        controller?.display(viewModel)
    }
}
