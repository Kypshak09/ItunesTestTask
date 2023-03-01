//
//  RequestArtist.swift
//  ItunesTestTask
//
//  Created by Amir Zhunussov on 28.02.2023.
//

import Foundation

class SongRequest {
    
    static let shared = SongRequest()
    
    private init() {}
    
    func requestSong(keyword: String, handler: @escaping ([StructOfSong]?, Error?) -> Void) {
        
        guard keyword.count >= 3 else {
            
            handler(nil, nil)
            return
        }
        let urlString = "https://itunes.apple.com/search?term=\(keyword)"
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) {data, response, error in
            guard let data = data else {
            handler(nil, error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(Song.self, from: data)
                handler(result.results, nil)
            }
            catch {
                handler(nil, error)
            }
        }.resume()
    }
}
