//
//  AudioEditViewController.swift
//  MusicCatcher
//
//  Created by Lena on 2023/04/05.
//

import UIKit

class ReadyRecordViewController: UIViewController {
    
    // MARK: Properties

    private var recordButtonView = RecordButtonView()
    
    private var microphoneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: microphoneImageName)
        return imageView
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .custombackgroundGrayColor
        
        recordButtonView.homeReordCircleButton.addTarget(self,
                         action: #selector(startRecordButtonTapped(_:)),
                         for: .touchUpInside)
        
        [recordButtonView].forEach { view.addSubview($0) }
        recordButtonView.addSubview(microphoneImageView)
        configureLayout()
    }
}

extension ReadyRecordViewController {
    private func configureLayout() {
        recordButtonView.centerX(inView: view)
        recordButtonView.centerY(inView: view)
        recordButtonView.setWidth(width: CGFloat(recordButtonWidth))
        recordButtonView.setHeight(height: CGFloat(recordButtonHeight))
        
        microphoneImageView.centerX(inView: recordButtonView)
        microphoneImageView.centerY(inView: recordButtonView)
    }
}

extension ReadyRecordViewController {
    @objc func startRecordButtonTapped(_ sender: UIButton) {
        let recordingViewController = RecordingViewController()
        self.navigationController?.pushViewController(recordingViewController, animated: true)
    }
}
