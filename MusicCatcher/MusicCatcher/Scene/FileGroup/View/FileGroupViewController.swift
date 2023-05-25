//
//  FileGroupViewController.swift
//  MusicCatcher
//
//  Created by Lena on 2023/04/30.
//

import UIKit

class FileGroupViewController: UIViewController {
    
    // MARK: - properties
    
    var items = AudioModel.items
    var folderNames = ["전체"]
    
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
                                  trailing: view.trailingAnchor,
                                  paddingLeading: 16,
                                  paddingTrailing: 16)
    }
    
    @objc func editButtonTapped(_ sender: UIBarButtonItem) {
        let isEditing = fileGroupTableView.isEditing
        fileGroupTableView.setEditing(!isEditing, animated: true)
        sender.title = isEditing ? "Edit" : "Done"
    }
    

}

extension FileGroupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortFolders()
        return folderNames.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FileGroupTableViewCell.reuseIdentifier, for: indexPath) as! FileGroupTableViewCell
        let folderName = folderNames[indexPath.row]
        cell.folderLabel.text = folderNames[indexPath.row]
        cell.countLabel.text = String(countFolders(folderName))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let folderName = folderNames[indexPath.row]
        
        let fileListViewController = FileListViewController()
        fileListViewController.folderName = folderName
        
        fileListViewController.navigationItem.title = folderName
        self.navigationController?.pushViewController(fileListViewController, animated: true)
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

// MARK: - folder filter method

extension FileGroupViewController {
    private func countFolders(_ folderName: String) -> Int {
        if folderName == "전체" {
            return items.count
        } else {
            let count = items.filter { $0.folderName == folderName }.count
            return count
        }
    }
    
    private func sortFolders() {
        for item in items {
            if folderNames.contains(item.folderName) {
                print("if절 - folderNames: \(folderNames)")
                continue
            } else {
                folderNames.append(item.folderName)
                print("else 절 - folderNames: \(folderNames)")
            }
        }
    }
}
