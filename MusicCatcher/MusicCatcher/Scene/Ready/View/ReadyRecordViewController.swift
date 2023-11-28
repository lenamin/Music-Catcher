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
        imageView.sizeToFit()
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem?.isHidden = true
        navigationItem.title = "녹음하기"
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
        microphoneImageView.setWidth(width: 157)
        microphoneImageView.setHeight(height: 157)
    }
}

extension ReadyRecordViewController {
    @objc func startRecordButtonTapped(_ sender: UIButton) {
        let recordingViewController = RecordingViewController()
        self.navigationController?.pushViewController(recordingViewController, animated: true)
    }
}
