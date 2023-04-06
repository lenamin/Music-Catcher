//
//  AudioEditViewController.swift
//  MusicCatcher
//
//  Created by Lena on 2023/04/05.
//

import UIKit

class ReadyRecordViewController: UIViewController {
    
    // MARK: Properties
    
//    private var homeRecordCircleView = HomeRecordCircleView()
    private var recordButtonView = RecordButtonView()
    private var microphoneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: microphoneImageName)
        
        return imageView
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(recordButtonView)
        recordButtonView.addSubview(microphoneImageView)
        configureLayout()
        view.backgroundColor = .custombackgroundGrayColor
        
    }
    
    private func configureLayout() {
        recordButtonView.centerX(inView: view)
        recordButtonView.centerY(inView: view)
        recordButtonView.setWidth(width: screenWidth / 1.8)
        recordButtonView.setHeight(height: screenWidth / 1.8)
        
        microphoneImageView.centerX(inView: recordButtonView)
        microphoneImageView.centerY(inView: recordButtonView)
    }
}
