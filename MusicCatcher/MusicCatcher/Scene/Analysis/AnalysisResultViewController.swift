//
//  AnalysisResultViewController.swift
//  MusicCatcher
//
//  Created by Lena on 11/1/23.
//

import UIKit
import CoreImage
import AVFoundation

import RxSwift
import RxCocoa

protocol SoundClassifierDelegate {
    func displayPredictionResult(identifier: String, confidence: Double)
}

// refernece: https://github.com/leoiphonedev/PulseAnimation-Swift.git
class AnalysisResultViewController: UIViewController, SoundClassifierDelegate {
    
    func displayPredictionResult(identifier: String, confidence: Double) {
        let percentConfidence = String(format: "%.2f", confidence)
        let myIdentifier = identifierTranslationHelper.identifier[identifier]
        print("identifier: \(String(describing: myIdentifier)), percentConfidence: \(percentConfidence)")
    }
    
    private var resultsObserver = ResultsObserver.shared
    private var previousPrediction = [String]()
    
    let soundManager = SoundManager()
    private var identifierTranslationHelper = IdentifierTranslationHelper()
    
    private var disposeBag = DisposeBag()
    
    
    private var minuteLabel = UILabel()
    private var soundNotificationLabel = UILabel()
    private var soundResultsLabel = UILabel()
    
    var pulseLayers = [CAShapeLayer]()
    private var backgroundImage = UIImageView(image: UIImage(named: "background-purple"))
    
    var resultIdentifier: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsObserver.classifierDelegate = self

        Task { await createPulse() }
        view.backgroundColor = .white
        view.addSubview(backgroundImage)
        [minuteLabel, soundNotificationLabel, soundResultsLabel].forEach { backgroundImage.addSubview($0) }
        
        setLabel()
        configureLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        soundManager.startAudioEngine()
        soundManager.analyzeAudioAndGetAmplitude()
            .map { amplitude in
                return amplitude > 9.0
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                print("amplitude 출력완료")
            })
            .disposed(by: disposeBag)
        
        soundManager.resultsObserver.observePredictions()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] prediction in
                print("prediction: \(prediction)")
                print("prediction.identifier: \(prediction.identifier)")
                
                if let thisIdentifier = self?.resultsObserver.identifierHelper.identifier[prediction.identifier] {
                    print("thisIdentifier: \(thisIdentifier)")
                    self?.minuteLabel.text = "지금 나오는 악기는 "
                    self?.resultIdentifier = thisIdentifier
                    self?.soundNotificationLabel.text = "\(thisIdentifier) 소리에요"
                    if !(self?.previousPrediction.contains(thisIdentifier) ?? Bool()) {
                        self?.previousPrediction.append(thisIdentifier)
                    }
                    self?.soundResultsLabel.text = self?.previousPrediction.joined(separator: " ")
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        soundManager.stopAudioEngine()
        debugPrint("audio engine stopped")
    }
    
    private func createPulse() async {
        for _ in 0...4 {
            let circularPath = UIBezierPath(arcCenter: .zero, radius: screenWidth / 2.0, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            
            let pulseLayer = CAShapeLayer()
            
            pulseLayer.path = circularPath.cgPath
            pulseLayer.lineWidth = 8.0
            pulseLayer.fillColor = UIColor.clear.cgColor
            pulseLayer.lineCap = CAShapeLayerLineCap.round
            pulseLayer.opacity = 0.7
            
            pulseLayer.position = CGPoint(x: screenWidth / 2.0, y: screenHeight / 2.0)
            
            view.layer.addSublayer(pulseLayer)
            pulseLayers.append(pulseLayer)
        }
        Task {
            await animatePulses()
        }
    }
    
    func animatePulses() async {
        await animatePulse(index: 0)
        await Task.sleep(250_000_000)  // Sleeping for 0.2 seconds
        
        await animatePulse(index: 1)
        await Task.sleep(250_000_000)  // Sleeping for 0.2 seconds
        
        await animatePulse(index: 2)
        await Task.sleep(250_000_000)  // Sleeping for 0.2 seconds
        
        await animatePulse(index: 3)
        await Task.sleep(250_000_000)  // Sleeping for 0.2 seconds
        
        await animatePulse(index: 4)
        await Task.sleep(250_000_000)  // Sleeping for 0.2 seconds
    }
    
    func animatePulse(index: Int) async {
        pulseLayers[index].strokeColor = UIColor(white: 1.0, alpha: 0.5).cgColor
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 3.0
        scaleAnimation.fromValue = 0.0
        scaleAnimation.toValue = 2.0
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        scaleAnimation.repeatCount = .greatestFiniteMagnitude
        pulseLayers[index].add(scaleAnimation, forKey: "scale")
        
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.duration = 3.0
        opacityAnimation.fromValue = 0.8
        opacityAnimation.toValue = 0.1
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        opacityAnimation.repeatCount = .greatestFiniteMagnitude
        pulseLayers[index].add(opacityAnimation, forKey: "opacity")
    }
    
    private func configureLayout() {
        backgroundImage.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        minuteLabel.anchor(top: backgroundImage.topAnchor, leading: backgroundImage.leadingAnchor, paddingTop: 85, paddingLeading: 21)
        minuteLabel.setHeight(height: 24)
        
        soundNotificationLabel.anchor(top: minuteLabel.bottomAnchor, leading: backgroundImage.leadingAnchor, paddingTop: 8, paddingLeading: 21)
        soundNotificationLabel.setHeight(height: 50)
        
        soundResultsLabel.anchor(top: soundNotificationLabel.bottomAnchor, leading: view.leadingAnchor, bottom: backgroundImage.bottomAnchor, trailing: view.trailingAnchor)
        
        soundResultsLabel.setHeight(height: 400)
    }
    
    private func setLabel() {
        minuteLabel.setLabel(labelText: " 지금 ", backgroundColor: .black, weight: .medium, textSize: 16, labelColor: .white)
        soundNotificationLabel.setLabel(labelText: "음악을 듣고 있어요 ", backgroundColor: .clear, weight: .bold, textSize: 32, labelColor: .white)
        soundResultsLabel.setLabel(labelText: "", backgroundColor: .clear, weight: .bold, textSize: 36, labelColor: .white)
        soundResultsLabel.textColor = UIColor(white: 1.0, alpha: 0.5)
        soundResultsLabel.numberOfLines = 0
        soundResultsLabel.textAlignment = .justified
        soundResultsLabel.adjustsFontSizeToFitWidth = true
    }
}
