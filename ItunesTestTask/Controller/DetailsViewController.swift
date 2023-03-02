//
//  DetailsViewController.swift
//  ItunesTestTask
//
//  Created by Amir Zhunussov on 01.03.2023.
//

import UIKit
import SnapKit
import AVFoundation

class DetailsViewController: DetailsViewControllerUI {

    var song: StructOfSong?
    var audioPlayer: AVPlayer?

    @objc func playPauseButtonTapped() {
        guard let audioPlayer = audioPlayer else { return }
        
        if audioPlayer.timeControlStatus == .playing {
            audioPlayer.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            audioPlayer.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "Now playing"
        self.navigationController?.navigationBar.tintColor = UIColor(red:  0.992, green: 0.655, blue: 0.412, alpha: 1)
        
        nameOfSong.text = song?.trackName
        nameOfArtist.text = song?.artistName
        
        if let url = URL(string: song?.artworkUrl100 ?? "") {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            self.imageOfAlbum.image = UIImage(data: data)
                        }
                    }
                }
            }
        
        playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        
        if let previewUrl = song?.previewUrl, let url = URL(string: previewUrl) {
            let playerItem = AVPlayerItem(url: url)
            audioPlayer = AVPlayer(playerItem: playerItem)
        }
        configureConstraint()
    }
}
