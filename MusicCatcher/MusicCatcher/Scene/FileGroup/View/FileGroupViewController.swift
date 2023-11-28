//
//  FileGroupViewController.swift
//  MusicCatcher
//
//  Created by Lena on 2023/04/30.
//

import UIKit

import RxSwift
import RxCocoa

class FileGroupViewController: UIViewController {
    
    // MARK: - properties
    
    // MARK: folderNames, tag 관리 하는 UserDefaults & Rx properties
    var folderNames = ["전체"]
    let userDefaultsStandard = UserDefaults.standard
    let savedFolderNamesArray = "savedFolderNamesArray"
    
    private let folderNamesRelay = BehaviorRelay<[String]>(value: ["전체"])
    private let tagsRelay = BehaviorRelay<[String]>(value: [""])
    private var totalTags = [""]
    private let disposeBag = DisposeBag()

    // MARK: CoreDataManager
    var coreDataManager = CoreDataManager.shared
    
    private let fileGroupTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FileGroupTableViewCell.self, forCellReuseIdentifier: FileGroupTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .singleLine
        tableView.isUserInteractionEnabled = true
        return tableView
    }()
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItems()

        view.backgroundColor = .custombackgroundGrayColor
        [fileGroupTableView].forEach { view.addSubview($0) }
        
        fileGroupTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        // 추가된 폴더를 tableView에 반영
        folderNamesRelay
            .bind(to: fileGroupTableView.rx.items(cellIdentifier: FileGroupTableViewCell.reuseIdentifier, cellType: FileGroupTableViewCell.self)) { _ , element, cell in
                cell.folderLabel.text = element
                cell.countLabel.text = String(self.countFolders("전체"))
            }
            .disposed(by: disposeBag)
        
        configureUI()
    }
    
    @objc func addButtonTapped() {
        let alert = UIAlertController(title: "새로운 폴더 생성", message: "폴더 이름을 작성해주세요", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "폴더 이름을 입력해주세요"
        }
        
        let ok = UIAlertAction(title: "추가하기", style: .default) { ok in
            if let folderName = alert.textFields?.first?.text {
                if !folderName.isEmpty {
                    let previousFolderNames = self.folderNames
                    print("previousFolderNames : \(previousFolderNames)")
                    
                    // userDefaults에 previous 저장
                    self.userDefaultsStandard.set(self.folderNames, forKey: self.savedFolderNamesArray)
                    
                    // 입력한 폴더 folderNames에 추가
                    self.folderNames.append(folderName)
                    
                    // editedFolderNames에 folderNames를 반영하고 userDefaults에 저장
                    let editedFolderNames = self.folderNames
                    self.userDefaultsStandard.set(editedFolderNames, forKey: self.savedFolderNamesArray)
                    
                    print("userDefault: \(self.userDefaultsStandard.array(forKey: self.savedFolderNamesArray))")
                    
                    // Rx에 배열 추가
                    self.folderNamesRelay.accept(editedFolderNames)
                    print("추가된 editedFolderNames 확인 : \(editedFolderNames)")
                }
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel) { cancel in
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationItems()
    }

    private func configureUI() {
        fileGroupTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                  leading: view.leadingAnchor,
                                  bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                  trailing: view.trailingAnchor,
                                  paddingLeading: 16,
                                  paddingTrailing: 16)
    }
}

extension FileGroupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        sortFolders()
        sortTags()
        return totalTags.count
//        return (coreDataManager.getAudioSavedArrayFromCoreData() { }.filter { $0.folderName != "전체" }).count + 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FileGroupTableViewCell.reuseIdentifier, for: indexPath) as! FileGroupTableViewCell
        
//        folderNames =  Array(Set(coreDataManager.getAudioSavedArrayFromCoreData() { }.map { $0.folderName ?? "전체" }))

        print("folderNames = \(folderNames)")
        
        cell.folderLabel.text = folderNames[indexPath.row]
        cell.countLabel.text = String(countFolders("전체"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let folderName = folderNames[indexPath.row]
        print("didSelect한 folderName: \(folderName)")
        
        let fileListViewController = FileListViewController()
        fileListViewController.folderName = folderName
        fileListViewController.items = coreDataManager.audioEntityArray
        fileListViewController.navigationItem.title = folderName
        
        self.navigationController?.pushViewController(fileListViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { (action, sourceView, completionHandler) in
            print("삭제 swipe")
            // 삭제
            
            // 1) 배열에서 지우고
            self.folderNames.remove(at: indexPath.row)
            print("배열에서 지운 결과 값: \(self.folderNames)")
            
            // 2) userdefaults에서 배열에서 지워진 값 대체
            self.userDefaultsStandard.set(self.folderNames, forKey: self.savedFolderNamesArray)
            print("지워진 결과를 userDefaults에 저장한 값: \(self.userDefaultsStandard.array(forKey: self.savedFolderNamesArray))")
            
            self.folderNamesRelay.accept(self.folderNames)
            
            completionHandler(true)}
        deleteAction.backgroundColor = .systemRed
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfiguration
    }
}
     
// MARK: - folder filter method

extension FileGroupViewController {
    private func countFolders(_ folderName: String) -> Int {
        if folderName == "전체" {
            return coreDataManager.audioEntityArray.count
        } else {
            return coreDataManager.audioEntityArray.filter { $0.folderName == folderName }.count
        }
    }
    
    private func sortTags() {
        for audio in coreDataManager.audioEntityArray {
            guard let tags = audio.tags else { return }
            
            totalTags.append(contentsOf: tags.filter { totalTags.contains($0) })
            print("sortTags() 결과 - totalTags: \(totalTags)")
        }
        
    }

    private func sortFolders() {
        for audio in coreDataManager.audioEntityArray {
            
            guard let folderName = audio.folderName else { return }
            
            if folderNames.contains(folderName) {
                print("if절 - folderNames: \(folderNames)")
                continue
            } else {
                folderNames.append(folderName)
                print("else 절 - folderNames: \(folderNames)")
            }
        }
    }
}

//MARK: - navigationController 설정
extension FileGroupViewController {
    private func setNavigationItems() {
        
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "키워드를 입력해 검색하세요"
        searchController.obscuresBackgroundDuringPresentation = true
        
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
}

extension FileGroupViewController: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

    }
}
