//
//  SettingViewController.swift
//  MusicCatcher
//
//  Created by Lena on 11/20/23.
//

import UIKit
import MessageUI
import SnapKit

class SettingTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let titles = ["만든 사람", "리뷰 남기기", "개발자에게 연락하기"]
    
    private let settingsTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        table.alwaysBounceVertical = true
        table.backgroundColor = .systemGroupedBackground
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(settingsTableView)
        view.backgroundColor = .systemGroupedBackground
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        navigationItem.title = "설정"
        configure()
    }

    private func configure() {
        settingsTableView.snp.makeConstraints { make in
            make.bottom.leading.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "앱 정보"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        // 만든 사람
        case 0:
                let developerViewController = DeveloperViewController()
                self.navigationController?.pushViewController(developerViewController, animated: true)
        
        // 리뷰남기기
        case 1:
            if let appstoreURL = URL(string: "https://apps.apple.com/app/id6472619820") {
                var components = URLComponents(url: appstoreURL, resolvingAgainstBaseURL: false)
                components?.queryItems = [
                  URLQueryItem(name: "action", value: "write-review")
                ]
                guard let writeReviewURL = components?.url else {
                    return
                }
                UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
            }
                
            // 개발자에게 email 발송하기
            case 2:
                checkEmailAvailability()
                let composeViewController = MFMailComposeViewController()
                composeViewController.setToRecipients(["lenaminn@gmail.com"])
                composeViewController.setSubject("[Music Catcher] ")
                
                self.present(composeViewController, animated: true, completion: nil)
                
            default:
                break
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
        
        cell.settingLabel.text = titles[indexPath.row]
        return cell
    }
}

extension SettingTableViewController {
    private func checkEmailAvailability() {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
    }
}
