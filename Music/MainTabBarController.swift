//
//  MainTabBarController.swift
//  Music
//
//  Created by Artem Kovardin on 20.10.2019.
//  Copyright © 2019 Artem Kovardin. All rights reserved.
//

import UIKit
import SwiftUI

class MainTabBarController: UITabBarController {
    private var minimisedTopAnchorConstraint: NSLayoutConstraint!
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!
    
    let search: SearchViewController = SearchViewController.loadFromStoryboard()
    let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        tabBar.tintColor = #colorLiteral(red: 0.9725490196, green: 0.2509803922, blue: 0.3725490196, alpha: 1)
        
        setupTrackDetailView()
        
        var library = Library()
        library.trackDetailAnimateDelegate = self
        let host = UIHostingController(rootView: library)
        host.tabBarItem.image = #imageLiteral(resourceName: "library")
        host.tabBarItem.title = "Library"
        
        viewControllers = [
            host,
//            generateViewController(root: host, image: #imageLiteral(resourceName: "ios10-apple-music-library-5nav-icon"), title: "Library"),
            generateViewController(root: search, image: #imageLiteral(resourceName: "ios10-apple-music-search-5nav-icon"), title: "Search"),
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
    
    private func setupTrackDetailView() {
        trackDetailView.animateDelegate = self
        search.trackDetailAnimateDelegate = self
        trackDetailView.movingDelegate = search
        view.insertSubview(trackDetailView, belowSubview: tabBar)
        
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        maximizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minimisedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        
        maximizedTopAnchorConstraint.isActive = true
        bottomAnchorConstraint.isActive = true
        
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

// MARK: - TrackAnimateDelegate

extension MainTabBarController: TrackAnimateDelegate {
    func maximizeTrackDetail(model: SearchViewModel.Cell?) {
        minimisedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: {
                self.view.layoutIfNeeded()
                self.tabBar.alpha = 0
                self.trackDetailView.miniTrackView.alpha = 0
                self.trackDetailView.maxiTrackStackView.alpha = 1
            },
            completion: nil)
        
        guard let model = model else {return}
        trackDetailView.set(model: model)
    }
    
    func minimizeTrackDetails() {
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimisedTopAnchorConstraint.isActive = true
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: {
                self.view.layoutIfNeeded()
                self.tabBar.alpha = 1
                self.trackDetailView.miniTrackView.alpha = 1
                self.trackDetailView.maxiTrackStackView.alpha = 0
            },
            completion: nil)
    }
}
