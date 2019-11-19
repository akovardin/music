//
//  TrackCell.swift
//  Music
//
//  Created by Artem Kovardin on 23.10.2019.
//  Copyright © 2019 Artem Kovardin. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

protocol TrackCellViewModel {
    var iconUrlString: String? { get }
    var trackName: String { get }
    var artistName: String { get }
    var collectionName: String { get }
}

class TrackCell: UITableViewCell {
    static let reuseIdentifier = "TrackCell"
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionLabelName: UILabel!
    @IBOutlet weak var addTrackOutlet: UIButton!
    
    var cell: SearchViewModel.Cell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        trackImageView.image = nil
    }
    
    func set(viewModel: SearchViewModel.Cell) {
        self.cell = viewModel
        
        let savedTracks = UserDefaults.standard.savedTracks()
        let hasFavourite = savedTracks.firstIndex(where: {
            $0.trackName == self.cell?.trackName && $0.artistName == self.cell?.artistName
        }) != nil
        
        if hasFavourite {
            addTrackOutlet.isHidden = true
        } else {
            addTrackOutlet.isHidden = false
        }
        
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionLabelName.text = viewModel.collectionName
        trackImageView?.sd_setImage(with: URL(string: viewModel.iconUrlString ?? ""), completed: nil)
    }
    
    @IBAction func addTrackAction(_ sender: Any) {
        guard let cell = cell else { return }
        addTrackOutlet.isHidden = true
        var listOfTracks = UserDefaults.standard.savedTracks()
        
        listOfTracks.append(cell)
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: listOfTracks, requiringSecureCoding: false) {
            UserDefaults.standard.set(data, forKey: UserDefaults.favouritesTrackKey)
        }
    }
    
    @IBAction func showInfoAction(_ sender: Any) {
        if let track = UserDefaults.standard.object(forKey: UserDefaults.favouritesTrackKey) as? Data {
            if let decoded = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(track) as? [SearchViewModel.Cell] {
                decoded.map { (track) in
                    print(track.trackName)
                }
            }
        }
    }
}
