//
//  PlaylistViewController.swift
//  MusicCatcher
//
//  Created by Lena on 2023/04/30.
//

import UIKit
import AVFoundation
import CoreData

class PlaylistViewController: UIViewController {
    
    let tagColors: [UIColor] = [.customTagRed, .customTagSky, .customTagNavy, .customTagPink, .customTagGreen]
    var recorder: Recorder?
    let recorderFileManager = RecordFileManager.shared

    var items = AudioModel.items
    var item = AudioModel()
    var playViewModel = PlayViewModel()
    var recordingViewModel = RecordingViewModel()
    
    var isPlaying: Observable<Bool> = Observable(false)
    
    var audioData = AudioModel()
    let coreDataManager = CoreDataManager.shared
    // MARK: Properties
    
    var playAudio = AudioModel(url: String(), title: String(), tags: [String()], date: String(), context: String(), folderName: String())
    
    var tagsItem: [String]?
    
    public var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
    }()
    
    public var tagCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        
        layout.minimumLineSpacing = 5
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PlaylistTagCollectionviewCell.self, forCellWithReuseIdentifier: PlaylistTagCollectionviewCell.reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    public var contentTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .justified
        textView.font = .systemFont(ofSize: 22)
        textView.isScrollEnabled = true
        textView.textColor = .black
        return textView
    }()
    
    public var playSlider: UISlider = {
        let slider = UISlider()
        slider.thumbTintColor = .pointColor
        slider.tintColor = .pointColor
        slider.isContinuous = true
        slider.minimumValue = 0
        slider.addTarget(PlaylistViewController.self,
                         action: #selector(sliderValueChanged(_:)),
                         for: .valueChanged)
        return slider
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
        [dateLabel, tagCollectionView, playSlider, contentTextView, labelStackView, buttonStackView].forEach { view.addSubview($0) }
        
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
    
        playViewModel.setUpURL(URL(string: recorderFileManager.myURL))
        playViewModel.setAudioPlayer()
        playViewModel.setData()
        bind()
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPlayAudio()
        navigationController?.navigationBar.isHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(pushEditView(_ :)))
    }
    
    @objc func pushEditView(_ sender: UIBarItem) {
        pushEditView()
    }
    
    /// 1) editView로 넘어간다
    /// 2) CoreData에서 해당 ObjectID를 넘긴다
    func pushEditView() {
        let editViewController = EditViewController()
        self.navigationController?.pushViewController(editViewController, animated: true)
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
        playSlider.anchor(top: tagCollectionView.bottomAnchor,
                               leading: view.leadingAnchor,
                               trailing: view.trailingAnchor,
                               paddingTop: 30,
                               paddingLeading: 15,
                               paddingTrailing: 15)
        labelStackView.anchor(top: playSlider.bottomAnchor,
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
        playViewModel.playOrPause()
    }
    
    @objc func backwardButtonTapped(_ sender: UIButton) {
        // 5초 전으로 이동
        playViewModel.back()
    }
    
    @objc func forwardButtonTapped(_ sender: UIButton) {
        // 5초 후로 이동
        playViewModel.forward()
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        playViewModel.sliderChanged(Double(sender.value))
    }
    
    func getPlayAudio() {
        coreDataManager.audioEntityArray = coreDataManager.getAudioSavedArrayFromCoreData() {
            let filteredAudio = self.coreDataManager.audioEntityArray.filter { $0.url == self.recorderFileManager.myURL }.first
            self.navigationItem.title = filteredAudio?.title
            self.contentTextView.text = filteredAudio?.context
            self.dateLabel.text = filteredAudio?.date
            self.tagsItem = filteredAudio?.tags
            self.tagCollectionView.reloadData()
            
        }
    }
}

extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: db 정리하고 다시
        return tagsItem?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistTagCollectionviewCell.reuseIdentifier, for: indexPath) as? PlaylistTagCollectionviewCell else { return UICollectionViewCell() }
        
        cell.tagLabel.text = tagsItem?[indexPath.row]
        
        if indexPath.row > tagColors.count {
             cell.backgroundColor = tagColors[indexPath.row - tagColors.count]
        } else {
             cell.backgroundColor = tagColors[indexPath.row]
        }
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()

        label.text = tagsItem?[indexPath.row]
        return CGSize(width: 50 + label.intrinsicContentSize.width, height: 32)
    }
    
}

extension PlaylistViewController {
    func bind() {
        
        playViewModel.playerProgress.bind { value in
            self.playSlider.value = Float(value)
        }
        
        playViewModel.playerTime.bind { time in
            self.playingTimeLabel.text = time.elapsedText
            self.endTimeLabel.text = time.remainingText
        }
        
        playViewModel.isPlaying.bind { status in
            if status == false {
                self.playButton.setImage(playImage, for: .normal)
            } else {
                self.playButton.setImage(pauseImage, for: .normal)
            }
        }
    }
}
