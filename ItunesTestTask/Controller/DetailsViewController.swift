//
//  DetailsViewController.swift
//  ItunesTestTask
//
//  Created by Amir Zhunussov on 01.03.2023.
//

import UIKit
import SnapKit
import AVFoundation

class DetailsViewController: UIViewController {

    var song: StructOfSong?
    var audioPlayer: AVPlayer?
    
    let playPauseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = UIColor(red:  0.992, green: 0.655, blue: 0.412, alpha: 1)
        button.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let viewOfNames: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let nameOfSong: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red:  0.992, green: 0.655, blue: 0.412, alpha: 1)
        label.numberOfLines = 3
        label.textAlignment = .center
        label.font = UIFont(name: "Arial Bold", size: 18)
        return label
    }()
    
    let nameOfArtist: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial", size: 18)
        label.textColor = .white
        return label
    }()
    
    let imageOfAlbum: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 15
        image.layer.masksToBounds = true
        return image
    }()
    
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
        
        if let previewUrl = song?.previewUrl, let url = URL(string: previewUrl) {
            let playerItem = AVPlayerItem(url: url)
            audioPlayer = AVPlayer(playerItem: playerItem)
        }
        configureConstraint()
        
    }
    
    private func configureConstraint() {
        view.addSubview(viewOfNames)
        viewOfNames.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(450)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.width.equalTo(146)
        }
        viewOfNames.addSubview(nameOfSong)
        nameOfSong.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
        }
        viewOfNames.addSubview(nameOfArtist)
        nameOfArtist.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(imageOfAlbum)
        imageOfAlbum.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(270)
        }
        
        view.addSubview(playPauseButton)
        playPauseButton.snp.makeConstraints { make in
            make.top.equalTo(viewOfNames.snp.bottom).offset(35)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
    }
}
