//
//  SearchInteractor.swift
//  Music
//
//  Created by Artem Kovardin on 23.10.2019.
//  Copyright (c) 2019 Artem Kovardin. All rights reserved.
//

import UIKit

protocol SearchBusinessLogic {
    func makeRequest(request: Search.Model.Request.RequestType)
}

class SearchInteractor: SearchBusinessLogic {
    private let network = NetworkService()
    var presenter: SearchPresentationLogic?
    var service: SearchService?
    
    func makeRequest(request: Search.Model.Request.RequestType) {
        if service == nil {
            service = SearchService()
        }
        
        switch request {
        case .getTracks(let searchTerm):
            self.presenter?.presentData(response: Search.Model.Response.ResponseType.presentFooterView)
            network.fetchTracks(searchText: searchTerm) { [weak self] response in
                self?.presenter?.presentData(response: Search.Model.Response.ResponseType.presentTracks(response: response))
            }
        }
    }
    
}
