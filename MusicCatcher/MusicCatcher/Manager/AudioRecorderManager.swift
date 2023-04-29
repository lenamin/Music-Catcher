//
//  AudioRecorderManager.swift
//  MusicCatcher
//
//  Created by Lena on 2023/04/29.
//

import UIKit
import AVFoundation

class AudioRecorderManager {
    
    typealias RecorderDelegates = AVAudioRecorderDelegate & RecorderDelegate
    typealias PlayerDelegates = AVAudioPlayerDelegate & PlayerDelegate
    
    // MARK: properties
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var meterTimer: Timer?
    private var isRecordPermissionGranted: Bool?
    private var isRecording = false
    private var isPausedRecording = false
    private var isPlaying = false
    private var recorderDelegate: (any RecorderDelegates)?
    private var playerDelegate: (any PlayerDelegates)?
    
//    private lazy var recordURL: URL = {
//        var documentsURL: URL = {
//            // TODO:  filemanager path 작성하기
//        }
//    }
    
    init() {
        let audioSession = AVAudioSession.sharedInstance().recordPermission
        switch audioSession {
            case .denied:
                isRecordPermissionGranted = false
                break
            case .granted:
                isRecordPermissionGranted = true
                break
            case .undetermined:
                AVAudioSession.sharedInstance().requestRecordPermission { allowed in
                    self.isRecordPermissionGranted = allowed
                }
                break
            default:
                break
        }
    }
    
    public func setUpRecorderDelegate(_ delegate: any RecorderDelegates) {
        if recorderDelegate != nil {
            fatalError("레코더가 이미 작동중이에요 ")
        }
        recorderDelegate = delegate
    }
    
    public func setUpPlayerDelegate(_ delegate: any PlayerDelegates) {
        if isPlaying {
            // stopPlaying() 구현하기
        }
        playerDelegate = delegate
    }
    
    private func getFileUrl(byName filename: String) -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] // first
        let filePath = documentsDirectory
            .appendingPathComponent(FileName.audioDirectoryName, conformingTo: .directory)
            .appendingPathComponent(filename)
        return filePath
    }
    
    /// alert 창 띄우기
    private func displayAlert(title: String, description: String, buttonTitle: String = "OK") {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .cancel))
        
        let scene = UIApplication.shared.connectedScenes.first
        if let sceneDelegate = (scene?.delegate as? SceneDelegate) {
            sceneDelegate.window?.rootViewController?.present(alert, animated: true)
        }
    }
    
    // MARK: - Recorder
    
    private func prepareRecorder() {
        
        guard isRecordPermissionGranted ?? Bool() else {
            displayAlert(title: "Record Permission", description: "마이크 사용을 허용해주세요")
            return
        }
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
            try session.setActive(true)
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2, // stereo
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue // TODO: high보다 더 높은거있는지 체크해보기
            ]
            
            // TODO: 녹음되는 날짜 따로 뺄 수 있으면 빼자
            let dateFormatter = DateFormatter()
            dateFormatter.locale = .current
            dateFormatter.dateFormat = "yyyy-MM-dd, HH:MM:ss"
            print(dateFormatter.dateFormat ?? String())
            let audioName = dateFormatter.string(from: Date())
            
            audioRecorder = try AVAudioRecorder(
                url: getFileUrl(byName: audioName), // 위에 TODO 에서 지정하면 filename으로 들어갈 수 있게 구현하기
                settings: settings
                )
            audioRecorder?.delegate = recorderDelegate
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.updateMeters()
            audioRecorder?.prepareToRecord()
            
        } catch {
            displayAlert(title: "녹음 중 에러가 발생했습니다", description: error.localizedDescription)
        }
    }
    
    public func startRecording() {
        if isRecording {
            finishAudioRecording(isSuccessed: true)
            isRecording = false
        } else {
            prepareRecorder()
            
            audioRecorder?.record()
            meterTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
                self.updateAudioMeter(timer: timer)
            })
            recorderDelegate?.recordingDidStart()
            isRecording = true
        }
    }
    
    
    private func updateAudioMeter(timer: Timer) {
        guard audioRecorder?.isRecording ?? Bool() else { return }
        
        let current = audioRecorder?.currentTime ?? Double()
        let hour = Int((current / 60) / 60)
        let minute = Int(current / 60)
        let second = Int(current.truncatingRemainder(dividingBy: 60))
        let totalTimeString = String(format: "%02dh %02dm %02ds", hour, minute, second) // 두 자리수 정수인데 한자리라면 나머지를 0으로 채운다
        recorderDelegate?.recordingCurrentTiming(totalTimeString)
        audioRecorder?.updateMeters()
    }
    
    public func finishAudioRecording(isSuccessed: Bool) {
        guard isSuccessed else {
            displayAlert(title: "Alert!", description: "녹음이 정상적으로 종료되지 않았습니다")
            return
        }
        
        audioRecorder?.stop()
        meterTimer?.invalidate()
        audioRecorder = nil
        isRecording = false
        
//        coreRouter?.reloadAppData()
    }
    
    public func pauseRecording() {
        guard isRecording else { return }
        if isPausedRecording {
            isPausedRecording = false
            audioRecorder?.record()
            recorderDelegate?.recordingDidContinued()
        } else {
            isPausedRecording = true
            audioRecorder?.pause()
            recorderDelegate?.recordingDidPaused()
        }
    }
    
    // MARK: - Player
    
    private func preparePlay(file fileURL: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer?.delegate = playerDelegate
            audioPlayer?.prepareToPlay()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func startPlaying(file fileURL: URL) {
        if isPlaying {
            fatalError("이미 재생중입니다!")
        }
        if FileManager.default.fileExists(atPath: fileURL.path) {
            playerDelegate?.playerDidStart()
            preparePlay(file: fileURL)
            audioPlayer?.play()
            isPlaying = true
        } else {
            displayAlert(title: "Alert", description: "재생할 파일이 존재하지 않습니다")
        }
    }
    
    public func stopPlaying() {
        guard isPlaying else { return }
        audioPlayer?.stop()
        playerDelegate?.playerDidEnd()
        isPlaying = false
    }
    
    public func pausePlaying() {
        guard isPlaying else { return }
        audioPlayer?.pause()
        playerDelegate?.playerDidPaused()
        isPlaying = false
    }
    
}

protocol RecorderDelegate {
    func recordingDidStart()
    func recordingDidEnd()
    func recordingCurrentTiming(_: String)
    func recordingDidPaused()
    func recordingDidContinued()
}

protocol PlayerDelegate {
    func playerDidStart()
    func playerDidPaused()
    func playerDidEnd()
}
