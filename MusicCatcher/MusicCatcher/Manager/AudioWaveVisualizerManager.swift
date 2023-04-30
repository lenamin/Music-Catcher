//
//  AudioWaveVisualizerManager.swift
//  MusicCatcher
//
//  Created by Lena on 2023/04/10.
//
/*
import UIKit
import AVFoundation

class AudioWaveVisualizerManager: UIViewController {
    
    /// initial
    audioPlayer = try AVAudioPlayer(contentsOf: url)
    audioPlayer?.prepareToPlay()
    audioPlayer?.isMeteringEnabled = true  // important!

    /// Using timer to block player, and get the info you want
    audioWaveIndicator.reset() // reset panel, clear all data

    timer = Timer.scheduledTimer(timeInterval: 1 / 60,
                                target: self,
                                selector: #selector(timerAction),
                                userInfo: nil, repeats: true)
    audioPlayer?.play()

    /// Timer Action
    audioWaveIndicator.power = (audioPlayer?.averagePower(forChannel: 0) ?? 0)
    audioWaveIndicator.setNeedsDisplay() // repaint
    audioPlayer?.updateMeters() 
}
*/

/*
import AVFAudio
import SimpleAudioWaveIndicator
import UIKit

class ViewController: UIViewController {
//    @IBOutlet var audioWaveIndicator: SimpleAudioWaveIndicator!
    var audioPlayer: AVAudioPlayer?
    var timer: Timer?

   


}
*/
