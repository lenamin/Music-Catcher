//
//  PlayViewModel.swift
//  MusicCatcher
//
//  Created by Lena on 2023/05/12.
//

import Foundation
import AVFoundation

class PlayViewModel {
    // 옵셔널이 아니면 안되는 이유가 없으면 차라리 init 함수를 만들어라
    var url: URL? // -> 옵셔널일 필요가 없지
    var recorder: Recorder?
    var audioManager: Audio?
    let recorderFileManager = RecordFileManager.shared

    var playerTime: Observable<PlayerTime> = Observable(.zero)
    var playerProgress: Observable<Double> = Observable(0.0)
    var isPlaying: Observable<Bool> = Observable(false)
    
    // 얘를 init함수로 만들어
    func setUpURL(_ url: URL?) {
        print("SetUpURL completed :\(url)")
        self.url = url
    }
    /*
    init(_ url: URL) {
        self.url = url
    }
     */
    
    func setAudioPlayer(_ url: URL?) {
        
        if let url = url {
            do {
                if let file = try recorderFileManager.loadRecordFile(url) {
                    print("audio file set completed")
                    print("setAudio 끝")
                    audioManager = Audio(file)  
                } else {
                    print("AVAudioFile load에 실패함!!")
                }
            } catch {
                print("loadRecordFile error 발생함 ")
            }
        }
    }
    
    func setData() {
        print("setData 시작")
    
        guard let audioManager = audioManager else {
            return print("setData guard let 빠져버림")
        }

        audioManager.isPlaying.bind { value in
            print("binding value: \(value)")
          self.isPlaying.value = value
        }
        audioManager.playerProgress.bind { value in
          self.playerProgress.value = value
        }
        audioManager.playerTime.bind { value in
          self.playerTime.value = value
        }

        print("player data was set")
    }
    
    func stop() {
        audioManager?.stop()
        recorderFileManager.deleteRecordFile(recorderFileManager.recordName.value)
    }
    
    func playOrPause() {
        audioManager?.playOrPause()
    }

    func back() {
        audioManager?.skip(forwards: false)
    }

    func forward() {
        audioManager?.skip(forwards: true)
    }
    
    func sliderChanged(_ value: Double) {
        audioManager?.seek(to: value)
    }
}
