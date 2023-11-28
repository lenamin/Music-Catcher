//
//  DeveloperViewController.swift
//  MusicCatcher
//
//  Created by Lena on 11/20/23.
//

import UIKit

class DeveloperViewController: UIViewController {
    
    private var appIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppIcon")
        imageView.sizeToFit()
        imageView.layer.cornerRadius = 9
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Music Catcher"
        label.textColor = .black
        label.font = .systemFont(ofSize: 30, weight: .medium)
        return label
    }()
    
    private var nameContentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.text = "Music Catcher는 작곡가 및 음악을 만드는 일반인이 순간 떠오른 악상을 간편하게 녹음하고 보관 및 관리할 수 있는 iOS 음악 기록 앱입니다. 음성메모를 카테고라이징하고, 태그를 추가해 정리해보세요." + "또한 현재 듣고 있는 음악의 악기 분석 서비스를 경험해보세요"
        label.textAlignment = .center
        return label
    }()
    
    private var myImageHyemin: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "hyemin")
        return imageView
    }()
    
    private var myImageBY: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "by")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [appIcon, nameLabel, nameContentLabel, myImageHyemin, myImageBY].forEach { view.addSubview($0) }
        view.backgroundColor = .custombackgroundGrayColor
        configure()
    }
    
    private func configure() {
        appIcon.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalToSuperview().offset(100)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(appIcon.snp_bottomMargin).offset(20)
        }
        
        nameContentLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(nameLabel.snp_bottomMargin).offset(20)
        }
        
        myImageHyemin.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(nameContentLabel.snp_bottomMargin).offset(30)
            make.width.equalTo(126)
            make.height.equalTo(193)
        }
        
        myImageBY.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(myImageHyemin.snp_bottomMargin).offset(30)
            make.width.equalTo(145)
            make.height.equalTo(242)
        }
        
    }
}
