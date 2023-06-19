//
//  ViewController.swift
//  MusicCatcher
//
//  Created by Lena on 2023/04/05.
//

import UIKit
import AVFoundation
import CoreData

class RecordingViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    // MARK: - properties
    var player: AVAudioPlayer?
    let recorder = Recorder()
    let recorderFileManager = RecordFileManager.shared
    let recordingViewModel = RecordingViewModel()
    let playViewModel = PlayViewModel()
    var averagePowerList: [CGFloat] = []
    
    var isRecording: Bool = false
    var timer: Timer?
    //    let dbHelper = DBHelper.shared
    
    let coreDataManager = CoreDataManager.shared
    
    private var audioWaveView: SoundVisualizerView = {
        let waveView = SoundVisualizerView(frame: .zero)
        return waveView
    }()
    
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00:00" // TODO: dummy data 실시간 녹음 수 받도록 수정 필요
        // TODO: text 크기, 볼드 수정하기
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 46)
        label.setHeight(height: 45)
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        [leftListButton, middleRecordButton, rightStopButton].forEach { stackView.addArrangedSubview($0) }
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
        button.setPreferredSymbolConfiguration(.init(pointSize: 20), forImageIn: .normal)
        button.addTarget(self,
                         action: #selector(listButtonTapped(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var middleRecordButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 96, height: 96)
        button.setBackgroundImage(UIImage(named: "middle-circle.png"), for: .normal)
        button.isSelected = false
        button.setImage(recordImage, for: .normal)
        button.setImage(pauseImage, for: .selected)
        button.setPreferredSymbolConfiguration(.init(pointSize: 40), forImageIn: .normal)
        button.tintColor = .white
        button.addTarget(self,
                         action: #selector(recordButtonTapped(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var rightStopButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 66, height: 66)
        button.setBackgroundImage(UIImage(named: "left-right-circle.png"), for: .normal)
        button.setImage(stopImage, for: .normal)
        button.addTarget(self,
                         action: #selector(stopButtonTapped(_:)),
                         for: .touchUpInside)
        button.setPreferredSymbolConfiguration(.init(pointSize: 20), forImageIn: .normal)
        button.tintColor = .white
        return button
    }()
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .custombackgroundGrayColor
        [audioWaveView, timeLabel, buttonStackView].forEach { view.addSubview($0) }
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.isHidden = false
    }
    
    @objc func recordButtonTapped(_: UIButton) {
        if isRecording { // 녹음중이면
            timer?.invalidate()
            recordingViewModel.recorder?.audioRecorder.stop()
            scrollWavedProgressView(translation: 0.0, point: CGPoint(x: 0.0, y: 0.0))
//            initAudioPlayer()
            middleRecordButton.setImage(recordImage, for: .normal)
        } else { // 녹음중이 아닐 때 녹음 시작해야지
            middleRecordButton.setImage(pauseImage, for: .normal)
            
            if !averagePowerList.isEmpty {
                self.audioWaveView.removeLayer()
                self.scrollWavedProgressView(translation: 0.0, point: CGPoint(x: 0.0, y: 0.0))
            }
            
            self.averagePowerList = []
            audioWaveView.xOffset = self.view.center.x / 3 - 1
            startRecording()
        }
        isRecording = !isRecording
    }
    
    @objc func stopButtonTapped(_: UIButton) {
        recordingViewModel.recorder?.audioRecorder.stop()
        recorder.displayLink = nil
        audioWaveView.removeLayer()
        self.scrollWavedProgressView(translation: 0.0, point: CGPoint(x: 0.0, y: 0.0))
        
        let alert = UIAlertController(title: "녹음완료!", message: "녹음된 파일을 저장하시겠습니까?", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "저장", style: .default, handler: { _ in
            guard let recorder = self.recordingViewModel.recorder?.audioRecorder else { return }
            do {
                print("originURL: \(recorder.url)")
                self.recorderFileManager.setRecordName()
                self.recorderFileManager.saveRecordFile(recordName: self.recorderFileManager.recordName.value,
                                                        file: recorder.url)
                print("recorderFileManager.myURL = \(self.recorderFileManager.myURL)")
                
                self.createNewAudioData(url: self.recorderFileManager.myURL,
                                                           title: self.recorderFileManager.recordName.value,
                                                           tags: ["+"],
                                                           date: MyDateFormatter.shared.dateToString(from: Date.now),
                                                           context: " ",
                                                           folderName: "전체")
                
                let playListViewController = PlaylistViewController()
                
                playListViewController.recorderFileManager.recordName.value = self.recorderFileManager.recordName.value
                playListViewController.recorderFileManager.myURL = self.recorderFileManager.myURL
                
                self.navigationController?.pushViewController(playListViewController, animated: true)
            }
        })
        let cancel = UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            self.timeLabel.text = "00 : 00"
            self.recorder.audioRecorder.stop()
        })
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        middleRecordButton.setImage(recordImage, for: .normal)
    
        isRecording = false
    }
    
    @objc func listButtonTapped(_: UIButton) {
        recordingViewModel.recorder?.audioRecorder.stop()
        let fileGroupViewController = FileGroupViewController()
        self.navigationController?.pushViewController(fileGroupViewController, animated: true)
    }
    
    func createNewAudioData(url: String, title: String, tags: [String], date: String, context: String, folderName: String) {

        let thisAudioModel = AudioModel(url: url, title: title, tags: tags, date: date, context: context, folderName: folderName)

        coreDataManager.createAudioData(with: thisAudioModel) {
            self.coreDataManager.audioEntityArray = self.coreDataManager.getAudioSavedArrayFromCoreData() {
                print("완료됨")
            }
        }
        debugPrint("createNewAudioData executed")
    }
}

extension RecordingViewController {
    private func configureUI() {
        audioWaveView.setHeight(height: 160)
        audioWaveView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             leading: view.leadingAnchor,
                             bottom: timeLabel.topAnchor,
                             trailing: view.trailingAnchor,
                             paddingTop: 120,
                             paddingBottom: 20)
        timeLabel.anchor(top: audioWaveView.bottomAnchor,
                         bottom: buttonStackView.topAnchor,
                         paddingBottom: 180)
        timeLabel.centerX(inView: view)
        buttonStackView.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        buttonStackView.centerX(inView: view)
        buttonStackView.setHeight(height: 96)
    }
}

extension RecordingViewController {
    func bind() {
        recordingViewModel.currentTime.bind { time in
            self.timeLabel.text = time.currTimeText
        }
    }

    func scrollWavedProgressView(translation: CGFloat, point: CGPoint){
        audioWaveView.translation = translation
        audioWaveView.scrollLayer.scroll(point)
    }
    
    func setWavedProgress(){
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if let audioRecorder = self.recordingViewModel.recorder?.audioRecorder{
                audioRecorder.updateMeters()
                
                let db = audioRecorder.averagePower(forChannel: 0)
                self.averagePowerList.append(CGFloat(db))
                self.audioWaveView.volumes = self.normalizeSoundLevel(level: db)
                self.audioWaveView.setNeedsDisplay()
            }
        }
    }
    
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let lowLevel: Float = -50
        let highLevel: Float = -10
        var level = max(0.0, level - lowLevel)
        level = min(level, highLevel - lowLevel)
        return CGFloat(Float(level / (highLevel - lowLevel)))
    }
    
    func setTotalPlayTimeLabel(){
        if recordingViewModel.recorder?.audioRecorder != nil{
            let audioLenSec = Int(player!.duration)
            let min = audioLenSec / 60 < 10 ? "0" + String(audioLenSec / 60) : String(audioLenSec / 60)
            let sec = audioLenSec % 60 < 10 ? "0" + String(audioLenSec % 60) : String(audioLenSec % 60)
            print("totalPlayTime: \(min + ":" + sec)")
        }
    }
    
    func startRecording() {
        recordingViewModel.setAudioRecorder()
        recordingViewModel.setData()
        bind()
        recordingViewModel.recorder?.audioRecorder.delegate = self
        recordingViewModel.recorder?.audioRecorder.isMeteringEnabled = true
        recordingViewModel.recorder?.audioRecorder.record()
        self.setWavedProgress()
    }
    
}
