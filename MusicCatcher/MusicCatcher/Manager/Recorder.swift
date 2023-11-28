//
//  Recorder.swift
//  MusicCatcher
//
//  Created by Lena on 2023/05/12.
//

import Foundation
import AVFoundation


struct AudioRecorderTime {
    let currTimeText: String
    static let zero: AudioRecorderTime = .init(currTime: 0)
    
    init(currTime: Int) {
        currTimeText = AudioRecorderTime.formatted(time: currTime)
    }
    
    private static func formatted(time: Int) -> String {
        let audioLenSec = time
        let min = audioLenSec / 60 < 10 ? "0" + String(audioLenSec / 60) : String(audioLenSec / 60)
        let sec = audioLenSec % 60 < 10 ? "0" + String(audioLenSec % 60) : String(audioLenSec % 60)
        let formattedString = min + ":" + sec
        return formattedString
    }
}

class Recorder {
    
    var audioRecorder = AVAudioRecorder()
    var recordName: MusicCatcherObservable<String> = MusicCatcherObservable("default")
    var currTime: MusicCatcherObservable<AudioRecorderTime> = MusicCatcherObservable(.zero)
    var displayLink: CADisplayLink?
    
    init() {
        setupAudioRecorder()
    }
    
    public func setupAudioRecorder() {
        let fileURL = FileManager.default.urls(for: .documentDirectory,
                                               in: .userDomainMask)[0].appendingPathComponent("default.m4a")
        
        let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                      AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 1,
             AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .spokenAudio, options: .allowBluetooth)
            print("첫번째 do=== Recorder - setUpAudioRecorder 안에서 set Category 완료: \(fileURL)")
        
        } catch {
            print("첫번째 do=== error: \(error.localizedDescription)")
        }
        
        do {
            self.audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            print("두번쨰 do=== Recorder - setUpAudioRecorder 안에서 audioRecorder에 fileURL넣음: \(self.audioRecorder.url)")
            setupDisplayLink()
        } catch {
            print("두번째 do=== error: \(error.localizedDescription)")
        }
    }
    
    func pause(){
        displayLink?.isPaused = false
    }
    
    private func setupDisplayLink() {
        displayLink = CADisplayLink(
            target: self,
            selector: #selector(updateCurrTime)
        )
        displayLink?.add(to: .current, forMode: .default)
        displayLink?.isPaused = false
    }
    
    @objc private func updateCurrTime() {
        let time = Int(audioRecorder.currentTime)
        currTime.value = AudioRecorderTime(currTime: time)
    }
}
