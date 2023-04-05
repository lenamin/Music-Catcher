//
//  AudioEditViewController.swift
//  MusicCatcher
//
//  Created by Lena on 2023/04/05.
//

import UIKit

class ReadyRecordViewController: UIViewController {
    
    // MARK: Properties
    
    private var homeRecordCircleView = HomeRecordCircleView()
    
    private var microphoneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: microphoneImageName)
        
        return imageView
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(homeRecordCircleView)
        homeRecordCircleView.addSubview(microphoneImageView)
        configureLayout()
        view.backgroundColor = .custombackgroundGrayColor
        
    }
    
    private func configureLayout() {
        homeRecordCircleView.centerX(inView: view)
        homeRecordCircleView.centerY(inView: view)
        homeRecordCircleView.setWidth(width: screenWidth / 1.8)
        homeRecordCircleView.setHeight(height: screenWidth / 1.8)
        
        microphoneImageView.centerX(inView: homeRecordCircleView)
        microphoneImageView.centerY(inView: homeRecordCircleView)
    }
}
