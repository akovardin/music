//
//  SearchViewController.swift
//  Music
//
//  Created by Artem Kovardin on 20.10.2019.
//  Copyright © 2019 Artem Kovardin. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: UITableViewController {
    let searchController = UISearchController()
    let tracks = [TrackModel(trackName: "bad guy", artistName: "Billie Eilish"),
                  TrackModel(trackName: "bury a friend", artistName: "Billie Eilish")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let track = tracks[indexPath.row]
        cell.textLabel?.text = "\(track.trackName)\n\(track.artistName)"
        cell.textLabel?.numberOfLines = 2
        cell.imageView?.image = #imageLiteral(resourceName: "Image")
        
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let url = "https://itunes.apple.com/search?term=\(searchText)"
        Alamofire.request(url).responseData {resp in
            if let error = resp.error {
                print("error on request data: \(error)")
                return
            }
            
            guard let data = resp.data else { return }
            
            let str = String(data: data, encoding: .utf8)
            print(str)
        }
    }
}
