//
//  ViewController.swift
//  MusicCatcher
//
//  Created by Lena on 2023/04/05.
//

import UIKit

class RecordingViewController: UIViewController {

    // MARK: properties
    
    private var audioWaveView: UIView = {
        let waveView = UIView()
        waveView.backgroundColor = .pointColor
        return waveView
    }()
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .custombackgroundGrayColor
        [audioWaveView].forEach { view.addSubview($0) }
        configureUI()
    }
}

extension RecordingViewController {
    private func configureUI() {
        audioWaveView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, paddingBottom: 100)
        audioWaveView.setHeight(height: 300)
    }
}

