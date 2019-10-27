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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        trackImageView.image = nil
    }
    
    func set(viewModel: TrackCellViewModel) {
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionLabelName.text = viewModel.collectionName
        trackImageView?.sd_setImage(with: URL(string: viewModel.iconUrlString ?? ""), completed: nil)
    }
}
