//
//  SongTableViewCell.swift
//  ItunesTestTask
//
//  Created by Amir Zhunussov on 01.03.2023.
//

import UIKit
import SnapKit

class SongTableViewCell: UITableViewCell {

    
    let view: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        return view
    }()
    
    let artistName: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let trackName: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let imageOfAlbum: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 20
        return image
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        setConstraints()
    }
    func configure(model: StructOfSong) {
        artistName.text = model.artistName
        trackName.text = model.trackName
    }

    private func setConstraints() {
        self.addSubview(view)
        view.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-16)
            make.height.equalTo(68)
        }
        
        view.addSubview(trackName)
        trackName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(120)
            make.trailing.equalToSuperview()
        }
        
        view.addSubview(artistName)
        artistName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(120)
            make.trailing.equalToSuperview()
        }
        
        view.addSubview(imageOfAlbum)
        imageOfAlbum.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(50)
            make.width.height.equalTo(40)
        }
    }
    
}
