//
//  FileGroupTableViewCell.swift
//  MusicCatcher
//
//  Created by Lena on 2023/04/30.
//

import UIKit

class FileGroupTableViewCell: UITableViewCell {

    static let reuseIdentifier = "FileGroupTableViewCell"

    public var folderLabel: UILabel = {
        let label = UILabel()
        label.text = "발라드"
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .left
        return label
    }()
    
    public var countLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        return label
    }()
    
    private let groupImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = folderImage
        return imageView
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        configureCellLayout()
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    private func configureCellLayout() {
        [groupImage, folderLabel, countLabel].forEach { contentView.addSubview($0) }
        
        groupImage.anchor(leading: contentView.leadingAnchor,
                          trailing: folderLabel.leadingAnchor,
                          paddingLeading: 10,
                          paddingTrailing: 10)
        groupImage.centerY(inView: contentView)
        
        folderLabel.anchor(leading: groupImage.trailingAnchor,
                           trailing: countLabel.leadingAnchor,
                           paddingTrailing: 10)
        folderLabel.centerY(inView: contentView)
        
        countLabel.anchor(leading: folderLabel.trailingAnchor)
        countLabel.centerY(inView: contentView)
    }
    
}
