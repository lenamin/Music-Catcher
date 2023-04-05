//
//  HomeRecordCircleView.swift
//  MusicCatcher
//
//  Created by Lena on 2023/04/05.
//

import UIKit

class HomeRecordCircleView: UIView {
    
    lazy var homeReordCircleView: UIView = {
        let circleView = UIView()
        circleView.backgroundColor = .pointColor
        circleView.frame = CGRect(x: 0, y: 0, width: screenWidth / 1.5, height: screenWidth / 1.5)
        circleView.layer.cornerRadius = self.frame.width / 2
        circleView.clipsToBounds = true
        circleView.layer.masksToBounds = true
        return circleView
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureCircle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureCircle() {

        addSubview(homeReordCircleView)
        
        homeReordCircleView.anchor(top: self.topAnchor,
                                   leading: self.leadingAnchor,
                                   bottom: self.bottomAnchor, trailing: self.trailingAnchor)
        
        homeReordCircleView.setWidth(width: screenWidth / 1.5)
        homeReordCircleView.setHeight(height: screenHeight / 1.5)
    }

    
}
