//
//  PlaylistViewController.swift
//  MusicCatcher
//
//  Created by Lena on 2023/04/30.
//

import UIKit

class PlaylistViewController: UIViewController {
    
    let tagColors: [UIColor] = [.customTagRed, .customTagSky, .customTagNavy, .customTagPink, .customTagGreen]
    let audioEngineManager = AudioRecorderManager()
    var isPlaying = false
    var item = Item(title: String(), tags: [Tag](), date: String(), duration: Int(), context: String())
    // TODO: -
    // contentLabel tagLabel, playerBar, startTimeLabel, endTimeLabel, playingTimeLabel
    // playButton, nextButton, beforeButton
    
    // MARK: Properties
    
    public var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.text = "2023 - 03 - 05 14:23" // dummy
        return label
    }()
    
    public var tagCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        
        layout.minimumLineSpacing = 5
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PlaylistTagCollectionviewCell.self, forCellWithReuseIdentifier: PlaylistTagCollectionviewCell.reuseIdentifier)
//        collectionView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    public var contentTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .justified
        textView.font = .systemFont(ofSize: 20)
        textView.isScrollEnabled = true
        textView.textColor = .black
        return textView
    }()
    
    public var playProgressBar: UIProgressView = {
        let progressView = UIProgressView()
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 4)
        
        progressView.progressViewStyle = .default
        progressView.progressTintColor = .pointColor
        progressView.trackTintColor = .darkGray
        progressView.progress = 0.6 // dummy
        
        return progressView
    }()
    
    public var endTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "03:22" // dummy
        label.textColor = .gray
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    public var playingTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "02:30"
        label.textColor = .gray
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    public lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        [backwardButton, playButton, forwardButton].forEach { stackView.addArrangedSubview($0) }
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        [playingTimeLabel, endTimeLabel].forEach { stackView.addArrangedSubview($0) }
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 250
        return stackView
    }()
    
    private lazy var backwardButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 66, height: 66)
        button.setImage(UIImage(systemName: "backward.end.fill"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 30), forImageIn: .normal)
        button.tintColor = .black
        button.addTarget(self,
                         action: #selector(backwardButtonTapped(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 96, height: 96)
        button.setBackgroundImage(UIImage(named: "middle-circle.png"), for: .normal)
        button.isSelected = false
        button.setImage(playImage, for: .normal)
        button.setImage(pauseImage, for: .selected)
        button.setPreferredSymbolConfiguration(.init(pointSize: 30), forImageIn: .normal)
        button.tintColor = .white
        
        button.addTarget(self,
                         action: #selector(playButtonTapped(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var forwardButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 66, height: 66)
        button.setImage(UIImage(systemName: "forward.end.fill"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 30), forImageIn: .normal)
        button.addTarget(self,
                         action: #selector(forwardButtonTapped(_:)),
                         for: .touchUpInside)
        button.tintColor = .black
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .custombackgroundGrayColor
        [dateLabel, tagCollectionView, playProgressBar, contentTextView, labelStackView, buttonStackView].forEach { view.addSubview($0) }
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func configureLayout() {
        dateLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         leading: view.leadingAnchor,
                         paddingLeading: 15)
        contentTextView.anchor(top: dateLabel.bottomAnchor,
                               leading: view.leadingAnchor,
                               trailing: view.trailingAnchor,
                               paddingLeading: 15,
                               paddingTrailing: 15)
        tagCollectionView.anchor(top: contentTextView.bottomAnchor,
                                 leading: view.leadingAnchor,
                                 trailing: view.trailingAnchor,
                                 paddingLeading: 15,
                                 paddingTrailing: 15)
        tagCollectionView.setHeight(height: 36)
        playProgressBar.anchor(top: tagCollectionView.bottomAnchor,
                               leading: view.leadingAnchor,
                               trailing: view.trailingAnchor,
                               paddingTop: 30,
                               paddingLeading: 15,
                               paddingTrailing: 15)
        labelStackView.anchor(top: playProgressBar.bottomAnchor,
                              leading: view.leadingAnchor,
                              trailing: view.trailingAnchor,
                              paddingTop: 15,
                              paddingLeading: 15,
                              paddingBottom: 15)
        buttonStackView.anchor(top: labelStackView.bottomAnchor,
                               bottom: view.safeAreaLayoutGuide.bottomAnchor)
        buttonStackView.centerX(inView: view)
    }
    
    @objc func playButtonTapped(_ sender: UIButton) {
        if isPlaying {
            audioEngineManager.pauseRecording()
            playButton.setImage(playImage, for: .normal)
        } else {
            audioEngineManager.startRecording()
            playButton.setImage(pauseImage, for: .normal)
        }
        isPlaying = !isPlaying
    }
    
    @objc func backwardButtonTapped(_ sender: UIButton) {
        // 이전 곡으로 이동
    }
    
    @objc func forwardButtonTapped(_ sender: UIButton) {
        // 다음곡으로 이동
    }
    
}

extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item.tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistTagCollectionviewCell.reuseIdentifier, for: indexPath) as? PlaylistTagCollectionviewCell else { return UICollectionViewCell() }
        
        cell.tagLabel.text = item.tags[indexPath.row].tag
        
        if indexPath.row > tagColors.count {
            cell.backgroundColor = tagColors[indexPath.row - tagColors.count]
        } else {
            cell.backgroundColor = tagColors[indexPath.row]
        }
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.text = item.tags[indexPath.row].tag
        return CGSize(width: 50 + label.intrinsicContentSize.width, height: 32)
    }
    
}
