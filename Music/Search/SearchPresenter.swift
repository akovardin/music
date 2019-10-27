//
//  SearchPresenter.swift
//  Music
//
//  Created by Artem Kovardin on 23.10.2019.
//  Copyright (c) 2019 Artem Kovardin. All rights reserved.
//

import UIKit

protocol SearchPresentationLogic {
    func presentData(response: Search.Model.Response.ResponseType)
}

class SearchPresenter: SearchPresentationLogic {
    weak var viewController: SearchDisplayLogic?
    
    func presentData(response: Search.Model.Response.ResponseType) {
        switch response {
        case .presentTracks(let searchResult):
            let cells = searchResult?.results.map({ (track) in
                cellViewModel(from: track)
            }) ?? []
            
            let searchViewModel = SearchViewModel(cells: cells)
            
            viewController?.displayData(viewModel: Search.Model.ViewModel.ViewModelData.displayTracks(searchViewModel: searchViewModel))
        case .presentFooterView:
            viewController?.displayData(viewModel: Search.Model.ViewModel.ViewModelData.displayFooterView)
        }
    }
    
    private func cellViewModel(from track: Track) -> SearchViewModel.Cell {
        return SearchViewModel.Cell(iconUrlString: track.artworkUrl100,
                                    trackName: track.trackName,
                                    collectionName: track.collectionName ?? "",
                                    artistName: track.artistName,
                                    previewUrl: track.previewUrl)
    }
}
