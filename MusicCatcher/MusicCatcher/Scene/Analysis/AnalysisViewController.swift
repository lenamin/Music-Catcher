//
//  AnalysisViewController.swift
//  MusicCatcher
//
//  Created by Lena on 10/8/23.
//

import UIKit

import RxSwift
import Lottie

enum AnalysisState {
    case analyzing
    case notAnalyzing
}


class AnalysisViewController: UIViewController {
    
    // MARK: Properties
    /*
    private var resultsObserver = ResultsObserver.shared
    private var previousPrediction = [String]()
    */
    private let soundManager = SoundManager()
    private var identifierTranslationHelper = IdentifierTranslationHelper()
    
    private var disposeBag = DisposeBag()
    
    /*
    var analysisState: AnalysisState = .notAnalyzing {
        
        didSet {
            updateButtonAppearance()
        }
    }
     */
    
//    let loadingAnimationView: LottieAnimationView = .init(name: "listening-animation")
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap하여 지금 나오는 음악을 분석해보세요"
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    lazy var listenButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 278, height: 278)
        button.layer.cornerRadius = CGFloat(button.bounds.width / 2)
        
        var config = UIButton.Configuration.plain()
        
        button.tintColor = .white
        button.setGradientColor(firstColor: .pointColor,
                                secondColor: .customGradientPurple,
                                startPointNumber: CGPoint(x: 0.0, y: 0.0),
                                endPointNumber: CGPoint(x: 0.0, y: 1.0))
        config.baseForegroundColor = .white
        button.setPreferredSymbolConfiguration(.init(pointSize: 80, weight: .bold, scale: .large), forImageIn: .normal)
        button.setImage(UIImage(systemName: "headphones"), for: .normal)
        
        button.configuration = config
        button.clipsToBounds = true
        
        button.addTarget(self,
                         action: #selector(tapAnalysisButton(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .custombackgroundGrayColor
        [descriptionLabel, listenButton].forEach { view.addSubview($0) }
//        listenButton.addSubview(loadingAnimationView)
//        loadingAnimationView.backgroundColor = .clear
//        loadingAnimationView.isHidden = true
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.isHidden = false
    }
    
    private func configureUI() {
        descriptionLabel.anchor(top: view.topAnchor,
                                paddingTop: 237)
        descriptionLabel.centerX(inView: view)
        
        listenButton.setWidth(width: 278)
        listenButton.setHeight(height: 278)
        listenButton.centerX(inView: view)
        listenButton.anchor(top: descriptionLabel.bottomAnchor, paddingTop: 32)
        /*
        loadingAnimationView.anchor(top: listenButton.topAnchor,
                                    leading: listenButton.leadingAnchor,
                                    bottom: listenButton.bottomAnchor,
                                    trailing: listenButton.trailingAnchor)
         */
    }
    
    
    func updateButtonAppearance() {
        
    }
        /*
        switch analysisState {
            case .notAnalyzing:
                loadingAnimationView.isHidden = true
                loadingAnimationView.pause()
                
                var config = UIButton.Configuration.plain()
                listenButton.tintColor = .white
                listenButton.setGradientColor(firstColor: .pointColor,
                                              secondColor: .customGradientPurple,
                                              startPointNumber: CGPoint(x: 0.0, y: 0.0),
                                              endPointNumber: CGPoint(x: 0.0, y: 1.0))
                config.baseForegroundColor = .white
                listenButton.setPreferredSymbolConfiguration(.init(pointSize: 80, weight: .bold, scale: .large), forImageIn: .normal)
                listenButton.setImage(UIImage(systemName: "headphones"), for: .normal)
                
            case .analyzing:
                // to make stop analyzing
                print("analyzing")
                
                descriptionLabel.text = "분석하고 있어요"
                
                listenButton.backgroundColor = .custombackgroundGrayColor
                
                listenButton.setGradientColor(firstColor: .custombackgroundGrayColor,
                                              secondColor: .custombackgroundGrayColor,
                                              startPointNumber: CGPoint(x: 0.0, y: 0.0),
                                              endPointNumber: CGPoint(x: 0.0, y: 1.0))
                
                listenButton.imageView?.isHidden = true
                listenButton.addSubview(loadingAnimationView)
                loadingAnimationView.isHidden = false
                loadingAnimationView.loopMode = .loop
                loadingAnimationView.play()
        }
    }
         */
}

extension AnalysisViewController {
    
    @objc func tapAnalysisButton(_ sender: Any) {
        /*
        print("analysisButton tapped!! Now State : \(analysisState) =====")
        analysisState = (analysisState == .notAnalyzing) ? .analyzing : .notAnalyzing
        
        if analysisState == .analyzing {
            startAnalyze()
        } else if analysisState == .notAnalyzing {
            stopAnalyze()
        }
         */
        print("tapped")
        let analysisResultViewController = AnalysisResultViewController()
        self.present(analysisResultViewController, animated: true)
        
    }
    

    /*
    func startAnalyze() {
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
                    self?.descriptionLabel.text = thisIdentifier
                    let analysisResultViewController = AnalysisResultViewController()
                    analysisResultViewController.resultIdentifier = thisIdentifier
                    self?.present(analysisResultViewController, animated: true)
                    self?.previousPrediction.append(thisIdentifier)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func stopAnalyze() {
        soundManager.stopAudioEngine()
        loadingAnimationView.isHidden = true
    }
     */
}
