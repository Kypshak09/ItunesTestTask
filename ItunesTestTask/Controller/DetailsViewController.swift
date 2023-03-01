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
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "play"), for: .normal)
        button.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let viewOfNames: UIView = {
        let view = UIView()
        return view
    }()
    
    let nameOfSong: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        label.font = UIFont(name: "Poppins-SemiBold", size: 18)
        return label
    }()
    
    let nameOfArtist: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.31, green: 0.31, blue: 0.31, alpha: 1)
        label.font = UIFont(name: "Poppins-Regular", size: 18)
        return label
    }()
    
    let imageOfAlbum: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 15
        return image
    }()
    
    @objc func playPauseButtonTapped() {
        guard let audioPlayer = audioPlayer else { return }
        
        if audioPlayer.timeControlStatus == .playing {
            audioPlayer.pause()
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            audioPlayer.play()
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Now playing"
        navigationItem.leftBarButtonItem?.tintColor = .black
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
            make.height.equalTo(45)
            make.centerX.equalToSuperview()
            make.width.equalTo(146)
        }
        viewOfNames.addSubview(nameOfSong)
        nameOfSong.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        viewOfNames.addSubview(nameOfArtist)
        nameOfArtist.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
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
            make.top.equalTo(viewOfNames.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
}
