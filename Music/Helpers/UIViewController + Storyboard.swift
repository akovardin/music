//
//  UIViewController + Storyboard.swift
//  Music
//
//  Created by Artem Kovardin on 23.10.2019.
//  Copyright © 2019 Artem Kovardin. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    class func loadFromStoryboard<T: UIViewController>() -> T {
        let name = String(describing: T.self)
        let storyboard = UIStoryboard(name: name, bundle: nil)
        if let controller = storyboard.instantiateInitialViewController() as? T {
            return controller
        } else {
            fatalError("Error: No initial view controllrt in \(name) storyboard!")
        }
    }
}
