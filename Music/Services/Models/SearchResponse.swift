//
//  SearchResponse.swift
//  Music
//
//  Created by Artem Kovardin on 24.10.2019.
//  Copyright © 2019 Artem Kovardin. All rights reserved.
//

import Foundation

struct SearchResponse: Decodable {
    var resultCount: Int
    var results: [Track]
}

struct Track: Decodable {
    var trackName: String
    var collectionName: String?
    var artistName: String
    var artworkUrl100: String?
    var previewUrl: String?
}
