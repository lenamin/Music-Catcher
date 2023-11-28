//
//  EditViewController.swift
//  MusicCatcher
//
//  Created by Lena on 2023/05/26.
//

import UIKit

class EditViewController: UIViewController {
    
    var recorder: Recorder?
    let recorderFileManager = RecordFileManager.shared
    let coreDataManager = CoreDataManager.shared
    
    /// editView에서 다룰 item
    var audioModel = AudioModel()
    var audioEntity = AudioEntity()
    var thisURL: URL?
    
    /// playViewModel.url에 값을 전달받음
    var playViewModel = RecordingPlayerViewModel()
    var recordingViewModel = RecordingViewModel()
    
    // MARK: Properties
    
    private var titleLabel = ReusableLabel(labelText: "제목", labelColor: .black, labelFont: .boldSystemFont(ofSize: 26))
    private var contextLabel = ReusableLabel(labelText: "메모", labelColor: .black, labelFont: .boldSystemFont(ofSize: 26))
    private var tagLabel = ReusableLabel(labelText: "태그", labelColor: .black, labelFont: .boldSystemFont(ofSize: 26))
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목 입력하기"
        textField.textAlignment = .left
        textField.font = .systemFont(ofSize: 20)
        textField.backgroundColor = .white
        return textField
    }()
    
    public var contentTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .justified
        textView.font = .systemFont(ofSize: 20)
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.sizeToFit()
        
        textView.text = "메모를 입력해주세요"
        textView.textColor = .placeholderText
        textView.backgroundColor = .white
        return textView
    }()
    
    private var keywordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "띄어쓰기로 구분해 태그 추가하기"
        textField.font = .systemFont(ofSize: 20)
        textField.backgroundColor = .white
        return textField
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("EditView에서 entityArray는: \(coreDataManager.audioEntityArray.debugDescription)")
        view.backgroundColor = .custombackgroundGrayColor
        [titleLabel, titleTextField, contextLabel, contentTextView, tagLabel, keywordTextField].forEach { view.addSubview($0) }
        contentTextView.delegate = self
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "편집하기"
        navigationItem.largeTitleDisplayMode = .never
        setUpData()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(doneButtonTapped(_:)))
    }
    
    private func configureLayout() {
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          paddingTop: 25,
                          paddingLeading: 15,
                          paddingTrailing: 15)
        
        titleTextField.anchor(top: titleLabel.bottomAnchor,
                              leading: view.leadingAnchor,
                              trailing: view.trailingAnchor,
                              paddingTop: 10,
                              paddingLeading: 15,
                              paddingTrailing: 15)
        titleTextField.setHeight(height: 40)
        contextLabel.anchor(top: titleTextField.bottomAnchor,
                            leading: view.leadingAnchor,
                            trailing: view.trailingAnchor,
                            paddingTop: 20,
                            paddingLeading: 15,
                            paddingTrailing: 15)
        contentTextView.anchor(top: contextLabel.bottomAnchor,
                               leading: view.leadingAnchor,
                               trailing: view.trailingAnchor,
                               paddingTop: 10,
                               paddingLeading: 15,
                               paddingTrailing: 15)
        contentTextView.setHeight(height: 200)
        tagLabel.anchor(top: contentTextView.bottomAnchor,
                        leading: view.leadingAnchor,
                        trailing: view.trailingAnchor,
                        paddingTop: 20,
                        paddingLeading: 15,
                        paddingTrailing: 15)
        keywordTextField.anchor(top: tagLabel.bottomAnchor,
                                leading: view.leadingAnchor,
                                trailing: view.trailingAnchor,
                                paddingTop: 10,
                                paddingLeading: 15,
                                paddingTrailing: 15)
        keywordTextField.setHeight(height: 40)
        
    }
    
    @objc func doneButtonTapped(_ sender: UIBarItem) {
        saveEditedData()
        self.navigationController?.popViewController(animated: false)
    }
    
    private func addTagsToArray(tags: String) -> [String] {
        var tagsArray: [String] = []
        (tags.split(separator: " ")).map { tagsArray.append(String($0)) }
        print("addTagsToArray: tags = \(tags), tagsArray: \(tagsArray)")
        return tagsArray
    }
    
    private func setUpData() {
        guard let thisAudioEntity = coreDataManager.audioEntityArray.first(where: { $0.url?.description == self.recorderFileManager.myURL }) else { return print("thisAudioModel 실패")}
        
        self.audioModel = FileListViewController().translateEntityToModel(audioEntity: thisAudioEntity)
        print("EditView에서 모델 가져오기 완료! 여기서 audioModel: \(self.audioModel.url)")
        
        self.titleTextField.text = self.audioModel.title
        self.contentTextView.text = self.audioModel.context
        self.keywordTextField.text = self.audioModel.tags?.joined(separator: " ")
    }
    
    private func saveEditedData() {
        guard let audioEntity = coreDataManager.audioEntityArray.filter({ $0.url == recorderFileManager.myURL }).first else { return print("saveEditedData() is failed") }
        
        if let isEmpty = titleTextField.text?.isEmpty {
            if isEmpty == true {
                audioEntity.title = audioEntity.date
            } else {
                audioEntity.title = titleTextField.text
            }
        }
        
        if let isEmpty = contentTextView.text?.isEmpty {
            if isEmpty == true {
                audioEntity.context = "내용없음"
            } else {
                audioEntity.context = contentTextView.text
            }
        }
        
        audioEntity.tags = addTagsToArray(tags: keywordTextField.text ?? "+")
        
        coreDataManager.updateAudio(with: audioEntity) {
            self.coreDataManager.getAudioSavedArrayFromCoreData() { results in
                self.coreDataManager.audioEntityArray = results
                self.setUpData()
            }
        }
    }
}


extension EditViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "메모를 입력해주세요" {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "메모를 입력해주세요"
            textView.font = .preferredFont(forTextStyle: .callout)
            textView.textColor = .lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oldString = textView.text,
                let newRange = Range(range, in: oldString) else { return true }
        let newString = oldString.replacingCharacters(in: newRange,
                                                      with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)
        
        let characterCount = newString.count
        guard characterCount <= 700 else { return false }
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.contentTextView.resignFirstResponder()
    }
}
