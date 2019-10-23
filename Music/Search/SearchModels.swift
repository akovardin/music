//
//  SearchModels.swift
//  Music
//
//  Created by Artem Kovardin on 23.10.2019.
//  Copyright (c) 2019 Artem Kovardin. All rights reserved.
//

import UIKit

enum Search {
   
  enum Model {
    struct Request {
      enum RequestType {
        case some
        case getTracks(searchText: String)
      }
    }
    struct Response {
      enum ResponseType {
        case some
        case presentTracks(response: SearchResponse?)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case some
        case displayTracks(searchViewModel: SearchViewModel)
      }
    }
  }
  
}

struct SearchViewModel {
    struct Cell: TrackCellViewModel {
        var iconUrlString: String?
        var trackName: String
        var collectionName: String
        var artistName: String
        var previewUrl: String?
    }
    
    let cells: [Cell]
}
