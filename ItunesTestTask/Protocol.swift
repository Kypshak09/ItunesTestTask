//
//  Protocol.swift
//  ItunesTestTask
//
//  Created by Amir Zhunussov on 01.03.2023.
//

import Foundation

protocol SongTableDetailDelegate: AnyObject {
    func didSelect(model: StructOfSong)
}
