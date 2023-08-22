//
//  MainTabBarViewController.swift
//  NawatechGallery
//
//  Created by Reynaldi on 23/08/23.
//

import UIKit

public final class MainTabBarViewController: UITabBarController {
    
    private let viewModels: [MainTabBarViewModel]
    
    public init(viewModels: [MainTabBarViewModel], nibName: String?, bundle: Bundle?) {
        self.viewModels = viewModels
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }

    private func configureView() {
        setViewControllers(viewModels.map { $0.controller }, animated: true)
        
        guard let tabBarItems = tabBar.items, tabBarItems.count == viewModels.count else { return }
        tabBarItems.enumerated().forEach { (index, item) in
            item.image = viewModels[index].imageNotSelected
            item.selectedImage = viewModels[index].imageSelected
        }
    }
}
