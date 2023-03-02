//
//  ViewControllerUI.swift
//  ItunesTestTask
//
//  Created by Amir Zhunussov on 02.03.2023.
//

import UIKit
import SnapKit

class ViewControllerUI: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
    }
    
    func setConstraints() {
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
