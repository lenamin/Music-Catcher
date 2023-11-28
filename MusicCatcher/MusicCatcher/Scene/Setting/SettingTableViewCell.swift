//
//  SettingTableViewCell.swift
//  MusicCatcher
//
//  Created by Lena on 11/20/23.
//

import UIKit
import SnapKit

class SettingTableViewCell: UITableViewCell {

    static let identifier = "SettingsTableViewCell"
    
    public let settingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configure()
    }
    
    private func configure() {
        contentView.addSubview(settingLabel)
        
        settingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(self.snp.leading).offset(20)
        }
    }
    
}
