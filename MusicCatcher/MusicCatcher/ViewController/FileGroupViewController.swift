//
//  FileGroupViewController.swift
//  MusicCatcher
//
//  Created by Lena on 2023/04/30.
//

import UIKit

class FileGroupViewController: UIViewController {
    
    // MARK: - properties
    
    var data = Folder.forders
    
    private let fileGroupTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FileGroupTableViewCell.self, forCellReuseIdentifier: FileGroupTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    public let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search keywords"
        return searchBar
    }()
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .custombackgroundGrayColor
        [fileGroupTableView].forEach { view.addSubview($0) }
        fileGroupTableView.delegate = self
        fileGroupTableView.dataSource = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "전체보기"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.topItem?.titleView = searchBar
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
        
    }
    
    private func configureUI() {
        fileGroupTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                  leading: view.leadingAnchor,
                                  bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                  trailing: view.trailingAnchor)
    }
    
    @objc func editButtonTapped(_ sender: UIBarButtonItem) {
        let isEditing = fileGroupTableView.isEditing
        fileGroupTableView.setEditing(!isEditing, animated: true)
        sender.title = isEditing ? "Edit" : "Done"
    }
}

extension FileGroupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FileGroupTableViewCell.reuseIdentifier, for: indexPath) as! FileGroupTableViewCell
        
        cell.folderLabel.text = data[indexPath.row].name
        cell.countLabel.text = String(data[indexPath.row].items.count)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let folder = data[indexPath.row]
        if folder != nil {
            let fileListViewController = FileListViewController()
            fileListViewController.items = folder.items
            fileListViewController.folderName = folder.name
            fileListViewController.navigationItem.title = folder.name
            
            self.navigationController?.pushViewController(fileListViewController, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
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
}
