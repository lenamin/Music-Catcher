//
//  FileListViewController.swift
//  MusicCatcher
//
//  Created by Lena on 2023/04/30.
//

import UIKit

class FileListViewController: UIViewController {
    
    var folderName: String = String()
    
    /// 모든 coredata audioentity들이 모여있는 배열
    var items = [AudioEntity]()
    
    /// 해당 View에 있는 배열
    var itemsFiltered = [AudioEntity]()
    
    let recorderFileManager = RecordFileManager.shared
    let coreDataManager = CoreDataManager.shared
    let player = Player.shared
    
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
        getFolderItem()
        [fileListTableView].forEach { view.addSubview($0) }
        fileListTableView.delegate = self
        fileListTableView.dataSource = self
        hidesBottomBarWhenPushed = false
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        items = setData()
    }
 
    private func configureUI() {
        fileListTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                 leading: view.leadingAnchor,
                                  bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                 trailing: view.trailingAnchor)
    }
    
    private func setData() -> [AudioEntity] {
        coreDataManager.getAudioSavedArrayFromCoreData { array in
            self.items = array.map { $0 }
            print("playListViewController에서 setData() 완료! \(self.items)")
        }
        return items
    }
}

// TODO: - "전체"인 경우 items 모두 나오게 세팅하기

extension FileListViewController {
    private func getFolderItem() {
        itemsFiltered.append(contentsOf: items.filter { $0.folderName == self.folderName })
//        print("getfolderItem()안 - itemsFiltered: \(itemsFiltered)")
    }
}

extension FileListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if folderName == "전체" {
            return items.count
        } else {
//            print("itemsFiltered: \(itemsFiltered)")
            return itemsFiltered.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FileListTableViewCell.reuseIdentifier, for: indexPath) as! FileListTableViewCell
        
        var item = AudioEntity()
        if folderName == "전체" {
            item = items[indexPath.row]
        } else {
            item = itemsFiltered[indexPath.row]
        }
        cell.titleLabel.text = item.title
        cell.tagLabel.text = item.tags?.joined(separator: ", ")
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
        
        if let audioURL = items[indexPath.row].url {
            
            if let url = URL(string: audioURL) {
                print("FileListViewController에서 tableViewCell didSelectRowAt 했을 때 ======= url: \(url)")
                let playListViewController = PlaylistViewController(url)
                playListViewController.playerViewModel.url = url
                
                self.navigationController?.pushViewController(playListViewController, animated: true)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
}

extension FileListViewController {
    public func translateEntityToModel(audioEntity: AudioEntity) -> AudioModel {
        let resultModel = AudioModel(url: audioEntity.url ?? "default",
                                     title: audioEntity.title ?? "title",
                                     tags: audioEntity.tags ?? ["+"],
                                     date: audioEntity.date ?? "",
                                     context: audioEntity.context ?? "",
                                     folderName: audioEntity.folderName ?? "전체")
        
        return resultModel
    }
}
