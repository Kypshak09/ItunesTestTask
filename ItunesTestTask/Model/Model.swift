//
//  Model.swift
//  ItunesTestTask
//
//  Created by Amir Zhunussov on 28.02.2023.
//

import Foundation

struct Song: Codable {
    let results: [StructOfSong]
}

struct StructOfSong: Codable {
    let artistName, trackName, kind: String
    let artworkUrl100: String
    let previewUrl: String
}
