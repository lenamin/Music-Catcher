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
    
    private let soundManager = SoundManager()
    private var identifierTranslationHelper = IdentifierTranslationHelper()
    private var disposeBag = DisposeBag()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap하여 지금 나오는 음악을 분석해보세요"
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    lazy var listenButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: recordButtonWidth, height: recordButtonWidth)
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
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func configureUI() {
        descriptionLabel.anchor(top: view.topAnchor,
                                paddingTop: 237)
        descriptionLabel.centerX(inView: view)
        
        listenButton.setWidth(width: CGFloat(recordButtonWidth))
        listenButton.setHeight(height: CGFloat(recordButtonHeight))
        listenButton.centerX(inView: view)
        listenButton.anchor(top: descriptionLabel.bottomAnchor, paddingTop: 32)
    }
}

extension AnalysisViewController {
    
    @objc func tapAnalysisButton(_ sender: Any) {
        print("tapped")
        let analysisResultViewController = AnalysisResultViewController()
        analysisResultViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(tapDoneButton))
        analysisResultViewController.navigationItem.rightBarButtonItem?.tintColor = .white

        let navigationController = UINavigationController(rootViewController: analysisResultViewController)
        self.present(navigationController, animated: true)
    }
    
    @objc func tapDoneButton() {
        self.dismiss(animated: true)
    }
}
