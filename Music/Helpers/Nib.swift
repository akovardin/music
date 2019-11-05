//
//  Nib.swift
//  Music
//
//  Created by Artem Kovardin on 06.11.2019.
//  Copyright © 2019 Artem Kovardin. All rights reserved.
//

import UIKit

extension UIView {
    
    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?.first as! T
    }
}
