//
//  RecordingViewModel.swift
//  MusicCatcher
//
//  Created by Lena on 2023/05/12.
//

import Foundation
import AVFoundation

class RecordingViewModel {
    var recorder: Recorder?
    var currentTime: MusicCatcherObservable<AudioRecorderTime> = MusicCatcherObservable(.zero)
    
    func setAudioRecorder() {
        recorder = Recorder()
    }
    
    func setData() {
        guard let recorder = recorder else { return }
        
        recorder.currTime.bind { value in
            self.currentTime.value = value
        }
    }
}
