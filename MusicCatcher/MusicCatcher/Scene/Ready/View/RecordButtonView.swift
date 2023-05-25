//
//  RecordButtonView.swift
//  MusicCatcher
//
//  Created by Lena on 2023/04/06.
//

import UIKit

final class RecordButtonView: UIView {
    
    ///  홈화면 시작할 때 누르는 CircleViewButton
    lazy var homeReordCircleButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.frame = CGRect(x: 0, y: 0, width: recordButtonWidth, height: recordButtonHeight)
        button.layer.cornerRadius = CGFloat(recordButtonWidth / 2)
        button.backgroundColor = nil
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        
        button.setGradientColor(firstColor: .pointColor,
                                secondColor: .customGradientPurple,
                                startPointNumber: CGPoint(x: 0.0, y: 0.0),
                                endPointNumber: CGPoint(x: 0.0, y: 1.0))
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
