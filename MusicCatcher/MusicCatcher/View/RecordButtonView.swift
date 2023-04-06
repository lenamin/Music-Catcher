//
//  RecordButtonView.swift
//  MusicCatcher
//
//  Created by Lena on 2023/04/06.
//

import UIKit

final class RecordButtonView: UIView {
    
    ///  홈화면 시작할 때 누르는 CircleViewButton 
    // TODO: gradient 색상 적용하기
    
    lazy var homeReordCircleButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .pointColor
        button.frame = CGRect(x: 0, y: 0, width: 216, height: 216)
        button.layer.cornerRadius = 108
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        button.addTarget(self,
                         action: #selector(startRecordButtonTapped(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureCircle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureCircle() {

        addSubview(homeReordCircleButton)
        
        homeReordCircleButton.anchor(top: self.topAnchor,
                                   leading: self.leadingAnchor,
                                   bottom: self.bottomAnchor,
                                   trailing: self.trailingAnchor)
    }
    
}

extension RecordButtonView {
    @objc func startRecordButtonTapped(_ sender: UIButton) {
        
        // TODO: RecordView로 전환 구현하기
        print("녹음이 시작됩니다")
    }
}
