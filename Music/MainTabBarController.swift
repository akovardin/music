//
//  MainTabBarController.swift
//  Music
//
//  Created by Artem Kovardin on 20.10.2019.
//  Copyright © 2019 Artem Kovardin. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        tabBar.tintColor = #colorLiteral(red: 0.9725490196, green: 0.2509803922, blue: 0.3725490196, alpha: 1)
        
        let search: SearchViewController = SearchViewController.loadFromStoryboard()
        let library = generateViewController(root: ViewController(), image: #imageLiteral(resourceName: "ios10-apple-music-library-5nav-icon"), title: "Library")
        
        viewControllers = [
            generateViewController(root: search, image: #imageLiteral(resourceName: "ios10-apple-music-search-5nav-icon"), title: "Search"),
            library,
        ]
    }
    
    private func generateViewController(root: UIViewController, image: UIImage, title: String) -> UIViewController {
        let navigation = UINavigationController(rootViewController: root)
        navigation.tabBarItem.image = image
        navigation.tabBarItem.title = title
        root.navigationItem.title = title
        navigation.navigationBar.prefersLargeTitles = true
        
        return navigation
    }
}
