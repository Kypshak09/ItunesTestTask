//
//  ViewController.swift
//  ItunesTestTask
//
//  Created by Amir Zhunussov on 28.02.2023.
//

import UIKit
import SnapKit

class ViewController: ViewControllerUI {
    
    private let identifier = "CellIdentifier"
    
    var songs = [StructOfSong]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List of Songs"
        tableView.register(SongTableViewCell.self, forCellReuseIdentifier: identifier)
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.bounces = false
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        indicatorOfActivity.hidesWhenStopped = true
        setConstraints()
    }
    
    
    func searchSong(keyword: String) {
        indicatorOfActivity.startAnimating()
        SongRequest.shared.requestSong(keyword: keyword) { songs, error in
            if let error = error {
                print("Error fetching songs: \(error)")
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Error", message: "Error fetching songs, try later", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default)
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                }
                return
            }
            guard let songs = songs else {
                print("No songs found for keyword")
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Error", message: "No songs found for your word, try another method", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default)
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                }
                return
            }
            
            let filteredSongs = songs.filter { $0.kind == "song" }
            self.songs = filteredSongs
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.indicatorOfActivity.stopAnimating()
            }
            }
    }
}

//MARK: - TableView delegate, data source, height
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! SongTableViewCell
        if indexPath.row % 2 == 0 {
            cell.view.backgroundColor = UIColor(red: 0.941, green: 0.955, blue: 0.97, alpha: 1)
        } else {
            cell.view.backgroundColor = .white
        }
        
        let song = songs[indexPath.row]
        cell.configure(model: song)
        if let url = URL(string: song.artworkUrl100) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            cell.imageOfAlbum.image = UIImage(data: data)
                        }
                    }
                }
            }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSong = songs[indexPath.row]
        let detailViewController = DetailsViewController()
        detailViewController.song = selectedSong
        self.navigationController?.pushViewController(detailViewController, animated: true)
//        present(detailViewController, animated: true)
    }
}
// MARK: - TextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let keyword = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "_").lowercased(),keyword.count >= 3,!keyword.isEmpty {
            searchSong(keyword: keyword)
        } else {
            songs = []
            tableView.reloadData()
        }
        return true
    }
    
}
