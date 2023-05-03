//
//  FileListTableViewCell.swift
//  MusicCatcher
//
//  Created by Lena on 2023/04/30.
//

import UIKit

class FileListTableViewCell: UITableViewCell {

    static let reuseIdentifier = "FileListTableViewCell"
    
    public var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.font = .boldSystemFont(ofSize: 22)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    public var tagLabel: UILabel = {
        let label = UILabel()
        label.text = "#"
        label.textAlignment = .left
        label.textColor = .gray
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        
        configureCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func configureCellLayout() {
        [titleLabel, tagLabel].forEach { contentView.addSubview($0) }
        
        titleLabel.anchor(top: contentView.topAnchor,
                          leading: contentView.leadingAnchor,
                          bottom: tagLabel.topAnchor,
                          paddingTop: 20,
                          paddingLeading: 10,
                          paddingBottom: 1)
        tagLabel.anchor(leading: contentView.leadingAnchor,
                        paddingLeading: 10)
    }

}
