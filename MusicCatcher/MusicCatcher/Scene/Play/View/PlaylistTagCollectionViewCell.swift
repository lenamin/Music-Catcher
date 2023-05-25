//
//  PlaylistTagCollectionViewCell.swift
//  MusicCatcher
//
//  Created by Lena on 2023/04/30.
//

import UIKit

class PlaylistTagCollectionviewCell: UICollectionViewCell {
    
    var tagColors: [UIColor] = [.customTagSky, .customTagPink, .customTagRed, .customTagGreen, .customTagNavy]
    
    static let reuseIdentifier: String = "PlaylistTagCollectionViewCell"
    
    public var tagLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "ballad"
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .white
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        contentView.backgroundColor = pickTagColor()
        layer.cornerRadius = 16
        layer.masksToBounds = true
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    private func pickTagColor() -> UIColor {
//        let setTagColors: Set = Set(tagColors)
////        let tagColor = tagColors.randomElement()
//        let tagColor = setTagColors.randomElement()
//        return tagColor ?? UIColor()
//    }
//
    
    func setConstraints() {
        contentView.addSubview(tagLabel)
        tagLabel.centerX(inView: contentView)
        tagLabel.centerY(inView: contentView)
        tagLabel.setHeight(height: 35)
    }
}
