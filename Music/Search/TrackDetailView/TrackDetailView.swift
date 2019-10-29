//
//  TrackDetailView.swift
//  Music
//
//  Created by Artem Kovardin on 28.10.2019.
//  Copyright © 2019 Artem Kovardin. All rights reserved.
//

import UIKit
import AVKit

class TrackDetailView: UIView {
    @IBOutlet weak var trackImageVIew: UIImageView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UIStackView!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    private var player: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let scale: CGFloat = 0.8
        trackImageVIew.transform = CGAffineTransform(scaleX: scale, y: scale)
        trackImageVIew.layer.cornerRadius = 5
        
        trackImageVIew.backgroundColor = .red
    }
    
    // MARK: - Setup
    
    func set(model: SearchViewModel.Cell)  {
        trackTitleLabel.text = model.trackName
        authorLabel.text = model.artistName
        playTrack(track: model.previewUrl)
        let img600 = model.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        trackImageVIew.sd_setImage(with: URL(string: img600 ?? ""), completed: nil)
    }
    
    private func playTrack(track url: String?) {
        guard let u = URL(string: url ?? "") else {return}
        player.replaceCurrentItem(with: AVPlayerItem(url: u))
    }
    
    // MARK: - Time setup
    
    private func monitorStartTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self.enlargeTrackImageView()
        }
    }
    
    // MARK: - Animations
    
    private func enlargeTrackImageView() {
        UIView.animate(
            withDuration: 1,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 1,
            options: .curveEaseInOut,
            animations: {
                self.trackImageVIew.transform = .identity
            },
            completion: nil)
        
    }
    
    private func reduceTrackImageView() {
        UIView.animate(
            withDuration: 1,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 1,
            options: .curveEaseInOut,
            animations: {
                let scale: CGFloat = 0.8
                self.trackImageVIew.transform = CGAffineTransform(scaleX: scale, y: scale)
            },
            completion: nil)
    }
    
    // MARK: - @IBAction
    
    @IBAction func dragDownButtonTapped(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    @IBAction func handleCurrentTimeSlider(_ sender: Any) {
    }
    
    @IBAction func handleVolumeSlider(_ sender: Any) {
    }
    
    @IBAction func previousTrack(_ sender: Any) {
    }
    
    @IBAction func nextTrack(_ sender: Any) {
    }
    
    @IBAction func playPauseAction(_ sender: Any) {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeTrackImageView()
        } else {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            reduceTrackImageView()
        }
    }
}
