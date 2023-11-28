//
//  PlayViewModel.swift
//  MusicCatcher
//
//  Created by Lena on 11/22/23.
//

import Foundation
import AVFoundation
import RxSwift
import RxCocoa

// TODO: 로직 수정중 
class PlayerViewModel {
    private var player: Player?
    private var disposeBag = DisposeBag()
    
    // Input
    let sliderValue = PublishRelay<Float>()
    let rewind5SecondsTrigger = PublishRelay<Void>()
    let forward5SecondsTrigger = PublishRelay<Void>()
    let playPauseTrigger = PublishRelay<Void>()
    
    // Output
    let startTimeSubject = BehaviorSubject<String>(value: "0:00")
    let endTimeSubject = BehaviorSubject<String>(value: "0:00")
    let isPlayingSubject = BehaviorSubject<Bool>(value: false)
    
    let playerProgress: BehaviorRelay<Float> = BehaviorRelay(value: 0.0)
    let playerTime: BehaviorRelay<(elapsed: String, remaining: String)> = BehaviorRelay(value: ("0:00", "0:00"))
    let isPlaying: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var url: URL?
    /*
    init(player: Player = .shared) {
        self.player = player
        print("PlayerViewModel에서 init함수가 실행되었다1 -> player: \(player.player)")
        setupBindings()
        bindActions()
        print("PlayerViewModel에서 init함수가 실행되었다2 -> player: \(player.player)")
    }
    */
    init() {
        setupBindings()
        bindActions()
    }
    
    func bindActions() {
        // Bind actions
        rewind5SecondsTrigger
            .subscribe(onNext: { [weak self] in
                self?.rewind5Seconds()
            })
            .disposed(by: disposeBag)
        
        forward5SecondsTrigger
            .subscribe(onNext: { [weak self] in
                self?.forward5Seconds()
            })
            .disposed(by: disposeBag)
        
        playPauseTrigger
            .subscribe(onNext: { [weak self] in
                self?.playPause()
            })
            .disposed(by: disposeBag)
        
    }
    
    private func setupBindings() {
        // Subscribe to player's duration changes
        if let player = player?.player {
            player.rx.observe(Double.self, "currentItem.duration.seconds")
                .compactMap { $0 }
                .subscribe(onNext: { [weak self] duration in
                    self?.endTimeSubject.onNext(self?.formattedTime(duration) ?? "0:00")
                })
                .disposed(by: disposeBag)
            
            // Subscribe to player's time changes
            player.rx.observe(Double.self, "currentTime().seconds")
                .compactMap { $0 }
                .subscribe(onNext: { [weak self] currentTime in
                    self?.startTimeSubject.onNext(self?.formattedTime(currentTime) ?? "0:00")
                })
                .disposed(by: disposeBag)
            
            // Subscribe to slider value changes
            sliderValue
                .subscribe(onNext: { [weak self] value in
                    self?.updatePlayerTime(value)
                })
                .disposed(by: disposeBag)
            
            // Subscribe to play/pause changes
            (player.rx.observe(Float.self, "rate") )
                .subscribe(onNext: { [weak self] rate in
                    self?.isPlayingSubject.onNext(rate == 1.0)
                })
                .disposed(by: disposeBag)
        }
        /*
        // Bind player progress
        playerProgress
            .bind(to: player?.rx.observe(Float.self, "currentItem.duration.seconds") ?? .empty())
            .map { duration in
                guard let duration = duration, duration > 0 else { return 0.0 }
                return Float((player?.currentTime().seconds ?? 0.0) / Float(duration))
            }
            .bind(to: playerProgress)
            .disposed(by: disposeBag)
        */
        // Bind player time
        playerTime
            .bind { [weak self] elapsed, remaining in
                self?.startTimeSubject.onNext(elapsed)
                self?.endTimeSubject.onNext(remaining)
            }
            .disposed(by: disposeBag)
        
        /*
         // Bind isPlaying
         (isPlayingSubject.asObservable() ?? .empty())
         .bind(to: player.rx.observe(Float.self, "rate").map { $0 == 1.0 } ?? .empty())
         .disposed(by: disposeBag)
         */
    }
    
    
    func rewind5Seconds() {
        guard let player = player?.player else { return }
        let newTime = max(player.currentTime().seconds - 5, 0)
        player.seek(to: CMTime(seconds: newTime, preferredTimescale: 1))
    }
    
    func forward5Seconds() {
        guard let player = player?.player, let duration = player.currentItem?.duration.seconds else { return }
        let newTime = min(player.currentTime().seconds + 5, duration)
        player.seek(to: CMTime(seconds: newTime, preferredTimescale: 1))
    }
    
    func playPause() {
        if let player = player?.player {
            isPlaying.value == false ? player.play() : player.pause()
//            player.rate == 0.0 ? player.play() : player.pause()
            print("=====PlayerViewModel에서 playPause() 메서드가 실행되었다")
        }
    }
    
    private func formattedTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private func updatePlayerTime(_ value: Float) {
        guard let player = player?.player, let duration = player.currentItem?.duration.seconds else { return }
        let newTime = Double(value) * duration
        player.seek(to: CMTime(seconds: newTime, preferredTimescale: 1))
    }
    
}
