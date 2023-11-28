//
//  PlayViewModel.swift
//  MusicCatcher
//
//  Created by Lena on 2023/05/12.
//

import Foundation
import AVFoundation

/// Recording 직후에 넘어갈 RecordingPlayerViewController에서 사용할 ViewModel
class RecordingPlayerViewModel {
    
    var url: URL?
    var audio : Audio?
    
    var playerTime: MusicCatcherObservable<PlayerTime> = MusicCatcherObservable(.zero)
    var playerProgress: MusicCatcherObservable<Double> = MusicCatcherObservable(0.0)
    var isPlaying: MusicCatcherObservable<Bool> = MusicCatcherObservable(false)
    
    /// 직전에 녹음했던거 재생하는 로직
    func setUpURL(_ url: URL) {
        self.url = url
    }
    
    func setUpAudio() {
        guard let url = url else { return }
        RecordFileManager.shared.saveRecordFile(recordName: RecordFileManager.shared.recordName.value, file: url)
        print("RecordingPlayerViewController에서 연결되는 viewmodel에서 recordName: \(RecordFileManager.shared.recordName.value)")
        
        guard let file = RecordFileManager.shared.loadRecordFile(url) else { return print("RecordingPlayerViewController에서 연결되는 viewmodel 에서 setUpAudio() 에서 loadRecordFile 실패") }
        audio = Audio(file)
    }
    
    func setupData() {
        guard let audio = audio else { return }
        audio.isPlaying.bind { value in
            self.isPlaying.value = value
        }
        audio.playerProgress.bind { value in
            self.playerProgress.value = value
        }
        audio.playerTime.bind { value in
            self.playerTime.value = value
        }
    }
    
    func stop() {
        audio?.stop()
        //        recorderFileManager.deleteRecordFile(recorderFileManager.recordName.value)
    }
    
    func playOrPause() {
        audio?.playOrPause()
    }
    
    func back() {
        audio?.skip(forwards: false)
    }
    
    func forward() {
        audio?.skip(forwards: true)
    }
    
    func sliderChanged(_ value: Double) {
        audio?.seek(to: value)
    }
}
