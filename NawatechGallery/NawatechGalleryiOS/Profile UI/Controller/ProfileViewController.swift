//
//  ProfileViewController.swift
//  NawatechGallery
//
//  Created by Reynaldi on 20/08/23.
//

import UIKit

public final class ProfileViewController: UIViewController {
    
    @IBOutlet private(set) public var profileImageView: UIImageView!
    @IBOutlet private(set) public var editProfileImageButton: UIButton!
    @IBOutlet private(set) public var nameLabel: UILabel!
    
    public var retrieveProfile: (() -> Void)?
    public var logout: (() -> Void)?

    public override func viewDidLoad() {
        super.viewDidLoad()

        configureInitialUI()
        
        retrieveProfile?()
    }
    
    private func configureInitialUI() {
        profileImageView.isHidden = true
        editProfileImageButton.isHidden = true
        nameLabel.isHidden = true
    }
    
    @IBAction private func didTapEditProfileImage(_ sender: Any) {}
    
    @IBAction func didTapLogout(_ sender: Any) {
    }
}
