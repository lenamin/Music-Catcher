//
//  ViewController.swift
//  MusicCatcher
//
//  Created by Lena on 2023/04/05.
//

import UIKit
import AVFoundation
import SimpleAudioWaveIndicator

class RecordingViewController: UIViewController {
    
    // MARK: properties
    
    // TODO: 추후 다이나믹 Audio Wave 구현하기 일단 뷰만 뜨도록 구현
    var audioWaveIndicator = SimpleAudioWaveIndicator()
    var audioPlayer: AVAudioPlayer?
    var timer: Timer?
    
    private var audioWaveView: UIView = {
        let waveView = UIView()
        waveView.backgroundColor = .pointColor
        return waveView
    }()
    
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "02:32" // TODO: dummy data 실시간 녹음 수 받도록 수정 필요
        // TODO: text 크기, 볼드 수정하기
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 46)
        label.setHeight(height: 45)
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        [leftListButton, middlePlayButton, rightStopButton].forEach { stackView.addArrangedSubview($0) }
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var leftListButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 66, height: 66)
        button.setBackgroundImage(UIImage(named: "left-right-circle.png"), for: .normal)
        button.setImage(listImage, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var middlePlayButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 96, height: 96)
        button.setBackgroundImage(UIImage(named: "middle-circle.png"), for: .normal)
        button.setImage(playImage, for: .normal)
        button.tintColor = .white

        button.addTarget(self,
                         action: #selector(playButtonTapped(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var rightStopButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 66, height: 66)
        button.setBackgroundImage(UIImage(named: "left-right-circle.png"), for: .normal)
        button.setImage(stopImage, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .custombackgroundGrayColor
        [audioWaveView, timeLabel, buttonStackView].forEach { view.addSubview($0) }
        
        /*
        
        let url = Bundle.main.url(forResource: "BGM_1", withExtension: "mp3")!

        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true)

            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.isMeteringEnabled = true
        } catch {
            print("Error:", error.localizedDescription)
        }

         */
        configureUI()
    }
    
    @objc func playStop(_: Any) {
        if audioPlayer?.isPlaying == true {
            audioPlayer?.stop()
            audioPlayer?.currentTime = 0
            timer?.invalidate()
        } else {
            audioWaveIndicator.reset()
            timer = Timer.scheduledTimer(timeInterval: 1 / 60, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            audioPlayer?.play()
        }
    }

    @objc func timerAction() {
        if audioPlayer?.isPlaying == true{
            audioWaveIndicator.power = (audioPlayer?.averagePower(forChannel: 0) ?? 0)
            audioWaveIndicator.setNeedsDisplay()
            audioPlayer?.updateMeters()
        }else {
            timer?.invalidate()
        }
    }
    
    @objc func playButtonTapped(_: UIButton) {
        middlePlayButton.setImage(pauseImage, for: .normal)

    }
    
}

extension RecordingViewController {
    private func configureUI() {
        audioWaveView.setHeight(height: 80)
        audioWaveView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             leading: view.leadingAnchor,
                             bottom: timeLabel.topAnchor,
                             trailing: view.trailingAnchor,
                             paddingTop: 252,
                             paddingBottom: 20)
        timeLabel.anchor(top: audioWaveView.bottomAnchor,
                         bottom: buttonStackView.topAnchor,
                         paddingBottom: 180)
        timeLabel.centerX(inView: view)
        buttonStackView.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        buttonStackView.centerX(inView: view)
//        buttonStackView.setWidth(width: 300)
        buttonStackView.setHeight(height: 96)
    }
}

