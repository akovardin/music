//
//  TrackDetailView.swift
//  Music
//
//  Created by Artem Kovardin on 28.10.2019.
//  Copyright © 2019 Artem Kovardin. All rights reserved.
//

import UIKit
import AVKit

protocol TrackMovingDelegate {
    func moveBack() -> SearchViewModel.Cell?
    func moveForvard() -> SearchViewModel.Cell?
}

protocol TrackAnimateDelegate {
    func minimizeTrackDetails()
    func maximizeTrackDetail(model: SearchViewModel.Cell?)
}

class TrackDetailView: UIView {
    @IBOutlet weak var trackImageVIew: UIImageView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationTimeLabel: UILabel!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    @IBOutlet weak var miniTrackView: UIView!
    @IBOutlet weak var miniForvardButton: UIButton!
    @IBOutlet weak var maxiTrackStackView: UIStackView!
    @IBOutlet weak var miniTrackTitleLabel: UILabel!
    @IBOutlet weak var miniTrackImageView: UIImageView!
    @IBOutlet weak var miniPlayPauseButton: UIButton!
    
    var movingDelegate: TrackMovingDelegate?
    var animateDelegate: TrackAnimateDelegate?
    
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
        
        setupGesture()
    }
    
    // MARK: - Setup
    
    func set(model: SearchViewModel.Cell)  {
        trackTitleLabel.text = model.trackName
        miniTrackTitleLabel.text = model.trackName
        authorLabel.text = model.artistName
        playTrack(track: model.previewUrl)
        observePlayerCurrentTime()
        monitorStartTime()
        playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        let img600 = model.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        trackImageVIew.sd_setImage(with: URL(string: img600 ?? ""), completed: nil)
        miniTrackImageView.sd_setImage(with: URL(string: img600 ?? ""), completed: nil)
    }
    
    private func setupGesture() {
        miniTrackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTabMaximized)))
        miniTrackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
    }
    
    private func playTrack(track url: String?) {
        guard let u = URL(string: url ?? "") else {return}
        player.replaceCurrentItem(with: AVPlayerItem(url: u))
        player.play()
    }
    
    // MARK: - Time setup
    
    private func monitorStartTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargeTrackImageView()
        }
    }
    
    private func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] t in
            self?.currentTimeLabel.text = t.toString()
            
            let durationTime = self?.player.currentItem?.duration
            let currentDuration = ((durationTime ?? CMTimeMake(value: 1, timescale: 1)) - t).toString()
            
            self?.durationTimeLabel.text = "-\(currentDuration)"
            
            self?.updateCurrentTimeSlider()
        }
    }
    
    private func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        
        let percentage = currentTimeSeconds / durationSeconds
        self.currentTimeSlider.value = Float(percentage)
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
        self.animateDelegate?.minimizeTrackDetails()
    }
    
    @IBAction func handleCurrentTimeSlider(_ sender: Any) {
        let percentage = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else {return}
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)
    }
    
    @IBAction func handleVolumeSlider(_ sender: Any) {
        player.volume = volumeSlider.value
    }
    
    @IBAction func previousTrack(_ sender: Any) {
        guard let model = movingDelegate?.moveBack() else {return}
        self.set(model: model)
    }
    
    @IBAction func nextTrack(_ sender: Any) {
        guard let model = movingDelegate?.moveForvard() else {return}
        self.set(model: model)
    }
    
    @IBAction func playPauseAction(_ sender: Any) {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeTrackImageView()
        } else {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            reduceTrackImageView()
        }
    }
    
    // MARK: - Maximazing and minimizing gestures
    @objc func handleTabMaximized() {
        self.animateDelegate?.maximizeTrackDetail(model: nil)
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            print("began")
        case .changed:
            handlePanChange(gesture: gesture)
        case .ended:
            handlePanEnded(gesture: gesture)
        @unknown default:
            print("uncnown")
        }
    }
    
    func handlePanChange(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        
        let newAlpha = 1 + translation.y / 200
        self.miniTrackView.alpha = newAlpha < 0 ? 0 : newAlpha
        self.maxiTrackStackView.alpha = -translation.y / 200
    }
    
    func handlePanEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: {
                self.transform = .identity
                if translation.y < -200 || velocity.y < -500 {
                    self.animateDelegate?.maximizeTrackDetail(model: nil)
                } else {
                    self.miniTrackView.alpha = 1
                    self.maxiTrackStackView.alpha = 0
                }
            },
            completion: nil)
    }
    
    @objc func handleDismissalPan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            let translation = gesture.translation(in: self.superview)
            maxiTrackStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        case .ended:
            let translation = gesture.translation(in: self.superview)
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 1,
                options: .curveEaseOut,
                animations: {
                    self.maxiTrackStackView.transform = .identity

                    if translation.y > 0 {
                        self.animateDelegate?.minimizeTrackDetails()
                    }
                },
                completion: nil)
        @unknown default:
            print("default")
        }
    }
}
