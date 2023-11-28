//
//  Player.swift
//  MusicCatcher
//
//  Created by Lena on 11/23/23.
//

import Foundation
import AVFoundation
import RxSwift
import RxCocoa

final class Player {
    
    static let shared = Player()
    var player: AVPlayer?
    private var session = AVAudioSession.sharedInstance()
    private init() {}
    deinit {
        disposeBag = DisposeBag()
    }
    
    var disposeBag = DisposeBag()
    
    private func activateSession() {
        print("activateSession 1")
        do {
            try session.setCategory(
                .playback,
                mode: .default,
                options: []
            )
        } catch _ { print("setCategory 실패") }
        /*
        do {
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch _ { print("setActive 실행 실패") }
        */
        print("activateSession 2")
        do {
            try session.overrideOutputAudioPort(.speaker)
        } catch _ { print("overrideOutputAudioPort 실행 실패")
        }
    }
    
    func deactivateSession() {
        do {
            try session.setActive(false, options: .notifyOthersOnDeactivation)
        } catch let error as NSError {
            print("Failed to deactivate audio session: \(error.localizedDescription)")
        }
    }
    
    func startPlayer(_ url: URL) {
        activateSession()
        let playerItem: AVPlayerItem = AVPlayerItem(url: url)
        print("startPlayer 내부 : playerItem: \(playerItem.description)")
        if let player = player {
            player.replaceCurrentItem(with: playerItem)
        } else {
            player = AVPlayer(playerItem: playerItem)
        }
        
        NotificationCenter.default.rx.notification(.AVPlayerItemDidPlayToEndTime)
            .take(1) // take only the first event
            .subscribe(onNext: { [weak self] _ in
                print(self)
                guard let strongSelf = self else { return }
                strongSelf.deactivateSession()
            })
            .disposed(by: disposeBag)
        
        if let player = player {
            player.play()
        }
    }
    
    func play() {
        if let player = player {
            player.play()
        }
    }
    
    func pause() {
        if let player = player {
            player.pause()
        }
    }
    
    func getPlaybackDuration() -> Double {
        guard let player = player else {
            return 0
        }
        
        return player.currentItem?.duration.seconds ?? 0
    }
    
}

