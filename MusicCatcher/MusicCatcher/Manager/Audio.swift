//
//  Audio.swift
//  MusicCatcher
//
//  Created by Lena on 2023/05/12.
//

import Foundation
import AVFoundation


class Audio {
//    let recorder = Recorder()
    
    let audioPlayer = AVAudioPlayerNode()
    var soundPlayer: AVAudioPlayer?
    
    let engine = AVAudioEngine()
    let pitchControl = AVAudioUnitTimePitch()
    var isPlaying: MusicCatcherObservable<Bool> = MusicCatcherObservable(false)
    var isPlayerReady = false
    var needsFileScheduled = true
    
    var audioFile: AVAudioFile?
    var audioSampleRate: Double = 0
    var audioLengthSeconds: Double = 0
    
    var playerProgress: MusicCatcherObservable<Double> = MusicCatcherObservable(0.0)
    var playerTime: MusicCatcherObservable<PlayerTime> = MusicCatcherObservable(.zero)
    
    var displayLink: CADisplayLink?
    var seekFrame: AVAudioFramePosition = 0
    var currentPosition: AVAudioFramePosition = 0
    var audioLengthSamples: AVAudioFramePosition = 0
    
    var currentFrame: AVAudioFramePosition {
        guard
            let lastRenderTime = audioPlayer.lastRenderTime,
            let playerTime = audioPlayer.playerTime(forNodeTime: lastRenderTime)
        else {
            return 0
        }
        return playerTime.sampleTime
    }
    
    init(recordFileURL: URL) {
        setupAudio(recordFileURL)
        setupDisplayLink()
        print("Audio 클래스 - init(_ recordFileURL) 함수 내에서 - init(_ recordFileURL: URL) executed")
    }
    
    init(savedSoundFileURL: URL) {
        setSoundPlayer(savedSoundFileURL)
        setupDisplayLink()
        print("Audio 클래스 - init(_ savedSoundFileURL) 함수 내에서 - init(_ savedSoundFileURL: URL) executed")
    }
    
    init(_ file: AVAudioFile) {
        setupAudio(file)
        setupDisplayLink()
        print("Audio 클래스 - init(_ file) 함수 내에서 - init(_file: AVAudioFile) executed")
    }
    
    private func setSoundPlayer(_ url: URL) {
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: url)
            soundPlayer?.prepareToPlay()
        } catch {
            print("Error loading sound file : \(error.localizedDescription)")
        }
    }
    
    private func setupAudio(_ url: URL) {
        print("setupAudio1. Audio클래스에 있는 setupAudio(_ url) 이 호출되었어!!!")
        
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback)
            try session.setActive(true)
            
            // AVAudioFile 생성 및 사용 코드...
            do {
                print("setupAudio2. Audio클래스에 있는 setupAudio(_ url) 내부의 do 로 들어옴")
              let file = try AVAudioFile(forReading: url)
              let format = file.processingFormat
                print("setupAudio3. Audio클래스에 있는 setupAudio(_ url) 에서 file, format 매칭 성공 === file: \(file.description), format: \(format)")
                
              audioLengthSamples = file.length
              audioSampleRate = format.sampleRate
              audioLengthSeconds = Double(audioLengthSamples) / audioSampleRate
              
              audioFile = file
              
              configureEngine(with: format)
            } catch {
              print("setupAudio 4. forReading 함수 호출 실패")
              print("Error reading the audio file: \(error.localizedDescription)")
            }
        } catch let error {
            print("Error setting up AVAudioSession: \(error.localizedDescription)")
        }
        

    }
    
    private func setupAudio(_ file: AVAudioFile) {
        print("setUpAudio(_ file) 함수 안에서 시작됨: \(file)")
        let format = file.processingFormat
        
        audioLengthSamples = file.length
        audioSampleRate = format.sampleRate
        audioLengthSeconds = Double(audioLengthSamples) / audioSampleRate
        audioFile = file
        
        configureEngine(with: format)
        print("setUpAudio(_ file) 함수 안에서 완료됨")
    }
    
    /*
    private func prepare() {
        engine.attach(audioPlayer)
        engine.attach(pitchControl)
        
        engine.connect(audioPlayer, to: pitchControl, format: nil)
        engine.connect(pitchControl, to: engine.mainMixerNode, format: nil)
        engine.prepare()
        print("Audio 클래스 - prepare() - engine 준비완료")
    } */
    
    private func configureEngine(with format: AVAudioFormat) {
        print("configureEngine 1. Audio클래스 - configureEngine 메서드 실행 시작")
        engine.attach(audioPlayer)
        engine.attach(pitchControl)
        
        engine.connect(audioPlayer, to: pitchControl, format: nil)
        engine.connect(pitchControl, to: engine.mainMixerNode, format: nil)
        print("configureEngine 2. Audio클래스 - configureEngine 메서드 내 connect 완료")
        engine.prepare()
        
        do {
            try engine.start()
            scheduleAudioFile()
            isPlayerReady = true
            print("configureEngine 3. Audio클래스 - configureEngine 메서드 - do 내 engine.start() 완료")
        } catch {
            print("Error starting the player: \(error.localizedDescription)")
        }
    }
    
    private func scheduleAudioFile() {
        guard
            let file = audioFile,
            needsFileScheduled
        else {
            return
        }
        
        needsFileScheduled = false
        seekFrame = 0
        
        audioPlayer.scheduleFile(file, at: nil) {
            self.needsFileScheduled = true
        }
    }
    
    func stop() {
        displayLink?.isPaused = true
//        engine.pause()
        audioPlayer.pause()
    }
    
    /*
    func playOrPause() {
        isPlaying.value.toggle()
        
        print("Audio클래스 - playOrPause()에서 isPlaying.value: \(isPlaying.value)")
        
        if audioPlayer.isPlaying {
            print("audioPlayer.isPlaying은?: \(audioPlayer.isPlaying)")
            displayLink?.isPaused = true
            audioPlayer.pause()
            print("audioPlayer.pause() executed")
        } else {
            displayLink?.isPaused = false
            
            if needsFileScheduled {
                scheduleAudioFile()
            }
            
            do {
                print("PlayOrPause 1. Audio클래스 - playOrPause() - do 안 - prepare() 후")
                try engine.start()
                print("PlayOrPause 2. Audio클래스 - playOrPause() - do 안 - engine.start() 후")
                scheduleAudioFile()
                isPlayerReady = true
                print("PlayOrPause 3. Audio클래스 - playOrPause() - do 안 - isPlayerReady? : \(isPlayerReady)")
                
                audioPlayer.play()
                print("PlayOrPause 4. Audio클래스 - playOrPause() - audioPlayer.play() executed")
                
            } catch {
                print("PlayOrPause Error starting the player: \(error.localizedDescription)")
            }
            
            
        }
    }
    */
    
    func playOrPause() {
        isPlaying.value.toggle()
        
        if audioPlayer.isPlaying {
            displayLink?.isPaused = true
            audioPlayer.pause()
        } else {
            displayLink?.isPaused = false
            
            if needsFileScheduled {
                scheduleAudioFile()
            }
            audioPlayer.play()
        }
    }
    
    
    func skip(forwards: Bool) {
        let timeToSeek: Double
        if forwards {
            timeToSeek = 5
        } else {
            timeToSeek = -5
        }
        seek(to: timeToSeek)
    }
    
    // MARK: - 5초 전,후를 위한 로직
    func seek(to time: Double) {
        guard let audioFile = audioFile else {
            return
        }
        
        let offset = AVAudioFramePosition(time * audioSampleRate)
        seekFrame = currentPosition + offset
        // 재생파일 시작과 끝을 넘어가는 case 대비
        seekFrame = max(seekFrame, 0)
        seekFrame = min(seekFrame, audioLengthSamples)
        currentPosition = seekFrame
        
        let wasPlaying = audioPlayer.isPlaying
        audioPlayer.stop()
        
        if currentPosition < audioLengthSamples {
            updateDisplay()
            needsFileScheduled = false
            
            let frameCount = AVAudioFrameCount(audioLengthSamples - seekFrame)
            audioPlayer.scheduleSegment(
                audioFile,
                startingFrame: seekFrame,
                frameCount: frameCount,
                at: nil
            ) {
                self.needsFileScheduled = true
            }
            
            if wasPlaying {
                audioPlayer.play()
            }
        }
    }
    
    // MARK: - 슬라이더
    func seekToPlay(to value: Float) {
        guard let audioFile = audioFile else {
            return
        }
        let sliderValue = audioLengthSeconds * Double(value) // Double
        seekFrame = AVAudioFramePosition(sliderValue * audioSampleRate)
        currentPosition = seekFrame
        
        let wasPlaying = audioPlayer.isPlaying
        audioPlayer.stop()
        
        if currentPosition < audioLengthSamples {
            updateDisplay()
            needsFileScheduled = false
            
            let frameCount = AVAudioFrameCount(audioLengthSamples - seekFrame)
            audioPlayer.scheduleSegment(
                audioFile,
                startingFrame: seekFrame,
                frameCount: frameCount,
                at: nil
            ) {
                self.needsFileScheduled = true
            }
            
            if wasPlaying {
                audioPlayer.play()
            }
        }
    }
    
    
    private func setupDisplayLink() {
        displayLink = CADisplayLink(
            target: self,
            selector: #selector(updateDisplay)
        )
        displayLink?.add(to: .current, forMode: .default)
        displayLink?.isPaused = true
    }
    
    
    @objc
    private func updateDisplay() {
        currentPosition = currentFrame + seekFrame
        currentPosition = max(currentPosition, 0)
        currentPosition = min(currentPosition, audioLengthSamples)
        
        if currentPosition >= audioLengthSamples {
            audioPlayer.stop()
            
            seekFrame = 0
            currentPosition = 0
            
            isPlaying.value = false
            displayLink?.isPaused = true
        }
        
        playerProgress.value = Double(currentPosition) / Double(audioLengthSamples)
        
        let time = Double(currentPosition) / audioSampleRate
        playerTime.value = PlayerTime(
            elapsedTime: time,
            remainingTime: audioLengthSeconds - time
        )
    }
}

