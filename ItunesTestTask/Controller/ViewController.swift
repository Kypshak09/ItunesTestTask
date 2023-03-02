//
//  ViewController.swift
//  ItunesTestTask
//
//  Created by Amir Zhunussov on 28.02.2023.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let identifier = "CellIdentifier"
    
    let tableView: UITableView = {
        let table = UITableView()
        return table
    }()
    
    let textField: UITextField = {
        let search = UITextField()
        search.backgroundColor = UIColor(red: 0.941, green: 0.955, blue: 0.97, alpha: 1)
        search.tintColor = .black
        search.placeholder = "Write your song"
        search.layer.cornerRadius = 5
        return search
    }()
    
    let indicatorOfActivity: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        return activity
    }()
    
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
                return
            }
            guard let songs = songs else {
                print("No songs found for keyword:")
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
    
    private func setConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(145)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(40)
        }
        
        view.addSubview(indicatorOfActivity)
        indicatorOfActivity.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.trailing.equalToSuperview().offset(-30)
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
