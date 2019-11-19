//
//  UserDefaults.swift
//  Music
//
//  Created by Artem Kovardin on 19/11/2019.
//  Copyright © 2019 Artem Kovardin. All rights reserved.
//

import Foundation

extension UserDefaults {
    static let favouritesTrackKey = "favouritesTrackKey"
    
    func savedTracks() -> [SearchViewModel.Cell] {
        let defaults = UserDefaults.standard
        
        guard let savedTracks = defaults.object(forKey: UserDefaults.favouritesTrackKey) as? Data else  { return [] }
        
        guard let decodeTracks = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedTracks) as? [SearchViewModel.Cell] else { return [] }
     
        return decodeTracks
    }
}
