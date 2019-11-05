//
//  CMTime + Extension.swift
//  Music
//
//  Created by Artem Kovardin on 31.10.2019.
//  Copyright © 2019 Artem Kovardin. All rights reserved.
//

import Foundation
import AVKit

extension CMTime {
    func toString() -> String {
        guard !CMTimeGetSeconds(self).isNaN else { return "" }
        let totalSecond = Int(CMTimeGetSeconds(self))
        let seconds = totalSecond % 60
        let minutes = totalSecond / 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
