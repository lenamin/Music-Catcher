//
//  FileListViewController.swift
//  MusicCatcher
//
//  Created by Lena on 2023/04/30.
//

import UIKit

class FileListViewController: UIViewController {
    
    var folderName: String = "Default"
    var items = [Item]()
    
    public let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search keywords"
        return searchBar
    }()
    
    private lazy var fileListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FileListTableViewCell.self, forCellReuseIdentifier: FileListTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .custombackgroundGrayColor
        [fileListTableView].forEach { view.addSubview($0) }
        fileListTableView.delegate = self
        fileListTableView.dataSource = self
        hidesBottomBarWhenPushed = false
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.inputViewController?.hidesBottomBarWhenPushed = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func configureUI() {
        fileListTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                 leading: view.leadingAnchor,
                                  bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                 trailing: view.trailingAnchor)
    }
}

extension FileListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FileListTableViewCell.reuseIdentifier, for: indexPath) as! FileListTableViewCell
        
        cell.titleLabel.text = items[indexPath.row].title
        cell.tagLabel.text = "#\(items[indexPath.row].tags[0].tag)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pinAction = UIContextualAction(style: .normal, title: "", handler: { action, view, completionHandler in
            print("pin")
            completionHandler(true)
            })
        pinAction.backgroundColor = .customGradientPurple
        pinAction.image = UIImage(systemName: "pin.fill")
        pinAction.image?.withTintColor(.white)
        
        return UISwipeActionsConfiguration(actions: [pinAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        if item != nil {
            /*
            let fileListViewController = FileListViewController()
            fileListViewController.items = item.items
            fileListViewController.folderName = item.name
            fileListViewController.navigationItem.title = item.name
            self.navigationController?.pushViewController(fileListViewController, animated: true)
             */
            let playListViewController = PlaylistViewController()
            playListViewController.item = item
            playListViewController.dateLabel.text = items[indexPath.row].date
            playListViewController.contentTextView.text = items[indexPath.row].context
            
            // TODO: navigation 설정 여기서 할 것
            playListViewController.navigationItem.title = items[indexPath.row].title
            self.navigationController?.pushViewController(playListViewController, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
